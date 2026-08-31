import Foundation
import SwiftUI
import Combine
#if canImport(FirebaseAuth)
import FirebaseAuth
#endif
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

// =========================================================
// ☁️ FIREBASE EXPENSE REPOSITORY WITH STRICT DATA ISOLATION
// =========================================================

public class FirebaseExpenseRepository: ObservableObject {
    @Published public var currentUser: AppUser?
    @Published public var transactions: [Transaction] = []
    @Published public var isCloudSynced: Bool = true
    @Published public var errorMessage: String?

    private let userDefaults = UserDefaults.standard
    private let userSessionKey = "kurd_current_user_session"
    private var listenerRegistration: Any?

    public init() {
        restoreSession()
    }

    // MARK: - 🔒 Session Management
    public func restoreSession() {
        if let data = userDefaults.data(forKey: userSessionKey),
           let user = try? JSONDecoder().decode(AppUser.self, from: data) {
            self.currentUser = user
            self.transactions = loadLocalTransactions(userId: user.uid)
            self.listenUserTransactions(userId: user.uid)
        }
    }

    private func persistUser(_ user: AppUser?) {
        self.currentUser = user
        if let user = user, let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userSessionKey)
        } else {
            userDefaults.removeObject(forKey: userSessionKey)
        }
    }

    // MARK: - 🔐 Authentication
    public func signIn(email: String, pass: String, completion: @escaping (Bool, String?) -> Void) {
        #if canImport(FirebaseAuth)
        Auth.auth().signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: pass) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    let msg = self?.translateError(error.localizedDescription) ?? error.localizedDescription
                    completion(false, msg)
                    return
                }
                guard let u = result?.user else {
                    completion(false, "User not found")
                    return
                }
                let appUser = AppUser(
                    uid: u.uid,
                    displayName: u.displayName ?? email.components(separatedBy: "@").first ?? "User",
                    email: u.email ?? email,
                    isGuest: false
                )
                self?.persistUser(appUser)
                self?.listenUserTransactions(userId: appUser.uid)
                completion(true, nil)
            }
        }
        #else
        // Mock fallback when testing without CocoaPods/SPM
        let mockUid = "user_" + UUID().uuidString.prefix(8)
        let appUser = AppUser(uid: String(mockUid), displayName: email.components(separatedBy: "@").first ?? "User", email: email, isGuest: false)
        self.persistUser(appUser)
        self.listenUserTransactions(userId: appUser.uid)
        completion(true, nil)
        #endif
    }

    public func signUp(name: String, email: String, pass: String, completion: @escaping (Bool, String?) -> Void) {
        #if canImport(FirebaseAuth)
        Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: pass) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    let msg = self?.translateError(error.localizedDescription) ?? error.localizedDescription
                    completion(false, msg)
                    return
                }
                guard let u = result?.user else {
                    completion(false, "Registration failed")
                    return
                }
                let chosenName = name.isEmpty ? (email.components(separatedBy: "@").first ?? "User") : name
                let changeRequest = u.createProfileChangeRequest()
                changeRequest.displayName = chosenName
                changeRequest.commitChanges { _ in
                    let appUser = AppUser(uid: u.uid, displayName: chosenName, email: u.email ?? email, isGuest: false)
                    self?.persistUser(appUser)
                    self?.saveUserDoc(uid: u.uid, name: chosenName, email: email, isGuest: false)
                    self?.listenUserTransactions(userId: appUser.uid)
                    completion(true, nil)
                }
            }
        }
        #else
        let mockUid = "user_" + UUID().uuidString.prefix(8)
        let appUser = AppUser(uid: String(mockUid), displayName: name.isEmpty ? "User" : name, email: email, isGuest: false)
        self.persistUser(appUser)
        self.listenUserTransactions(userId: appUser.uid)
        completion(true, nil)
        #endif
    }

    public func signInAsGuest(completion: @escaping (Bool, String?) -> Void) {
        #if canImport(FirebaseAuth)
        Auth.auth().signInAnonymously { [weak self] result, error in
            DispatchQueue.main.async {
                let uid = result?.user.uid ?? ("guest_" + UUID().uuidString.prefix(8))
                let appUser = AppUser(uid: String(uid), displayName: "میوان / Guest", email: "guest@kurdexpense.app", isGuest: true)
                self?.persistUser(appUser)
                self?.saveUserDoc(uid: appUser.uid, name: appUser.displayName, email: appUser.email, isGuest: true)
                self?.listenUserTransactions(userId: appUser.uid)
                completion(true, nil)
            }
        }
        #else
        let guestUid = "guest_" + UUID().uuidString.prefix(8)
        let appUser = AppUser(uid: String(guestUid), displayName: "میوان / Guest", email: "guest@kurdexpense.app", isGuest: true)
        self.persistUser(appUser)
        self.listenUserTransactions(userId: appUser.uid)
        completion(true, nil)
        #endif
    }

    public func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        #if canImport(FirebaseAuth)
        Auth.auth().sendPasswordReset(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines)) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, self?.translateError(error.localizedDescription) ?? error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
        #else
        completion(true, nil)
        #endif
    }

    public func signOut() {
        #if canImport(FirebaseAuth)
        try? Auth.auth().signOut()
        #endif
        self.persistUser(nil)
        self.transactions = []
    }

    // MARK: - 📁 Strictly Isolated Firestore Database
    public func listenUserTransactions(userId: String) {
        guard !userId.isEmpty else {
            self.transactions = []
            return
        }

        // 1. Instantly load offline cache for zero lag
        self.transactions = loadLocalTransactions(userId: userId)

        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        // Strict subcollection path: users/{userId}/transactions
        db.collection("users").document(userId).collection("transactions")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if error != nil {
                        self?.isCloudSynced = false
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    let list: [Transaction] = documents.compactMap { doc in
                        let d = doc.data()
                        guard let title = d["title"] as? String,
                              let category = d["category"] as? String,
                              let amount = d["amount"] as? Double,
                              let typeStr = d["type"] as? String,
                              let type = TxType(rawValue: typeStr),
                              let date = d["date"] as? Int64 else { return nil }
                        let note = d["note"] as? String ?? ""
                        return Transaction(id: doc.documentID, title: title, category: category, amount: amount, type: type, date: date, note: note, userId: userId)
                    }
                    self?.transactions = list
                    self?.saveLocalTransactions(userId: userId, txs: list)
                    self?.isCloudSynced = true
                }
            }
        #endif
    }

    public func addTransaction(transaction: Transaction) {
        guard let userId = currentUser?.uid, !userId.isEmpty else { return }

        // 1. Immediately update local memory & disk
        var current = self.transactions
        current.insert(transaction, at: 0)
        self.transactions = current
        saveLocalTransactions(userId: userId, txs: current)

        // 2. Sync to Firestore in background
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "title": transaction.title,
            "category": transaction.category,
            "amount": transaction.amount,
            "type": transaction.type.rawValue,
            "date": transaction.date,
            "note": transaction.note,
            "userId": userId,
            "createdAt": Int64(Date().timeIntervalSince1970 * 1000)
        ]
        db.collection("users").document(userId).collection("transactions")
            .document(transaction.id)
            .setData(data) { [weak self] error in
                DispatchQueue.main.async {
                    self?.isCloudSynced = (error == nil)
                }
            }
        #endif
    }

    public func deleteTransaction(id: String) {
        guard let userId = currentUser?.uid, !userId.isEmpty else { return }

        // 1. Local update
        let updated = self.transactions.filter { $0.id != id }
        self.transactions = updated
        saveLocalTransactions(userId: userId, txs: updated)

        // 2. Firestore delete
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("transactions").document(id).delete()
        #endif
    }

    private func saveUserDoc(uid: String, name: String, email: String, isGuest: Bool) {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "uid": uid,
            "name": name,
            "email": email,
            "isGuest": isGuest,
            "createdAt": Int64(Date().timeIntervalSince1970 * 1000),
            "currency": "IQD"
        ]
        db.collection("users").document(uid).setData(userData, merge: true)
        #endif
    }

    // MARK: - 💾 Local Storage
    private func localKey(userId: String) -> String {
        return "kurd_tx_cache_\(userId)"
    }

    private func loadLocalTransactions(userId: String) -> [Transaction] {
        guard let data = userDefaults.data(forKey: localKey(userId: userId)),
              let list = try? JSONDecoder().decode([Transaction].self, from: data) else {
            return []
        }
        return list
    }

    private func saveLocalTransactions(userId: String, txs: [Transaction]) {
        if let data = try? JSONEncoder().encode(txs) {
            userDefaults.set(data, forKey: localKey(userId: userId))
        }
    }

    // MARK: - 🌍 Error Translation
    private func translateError(_ raw: String) -> String {
        if raw.contains("password") || raw.contains("wrong") {
            return "تێپەڕەوشە (پاسۆرد) هەڵەیە یان لاوازە"
        }
        if raw.contains("email") || raw.contains("badly formatted") {
            return "ئیمەیڵەکە دروست نییە یان بە هەڵە نووسراوە"
        }
        if raw.contains("already in use") {
            return "ئەم ئیمەیڵە پێشتر هەژماری پێ دروستکراوە"
        }
        if raw.contains("network") || raw.contains("offline") {
            return "کێشەی هێڵی ئینتەرنێت هەیە"
        }
        return raw
    }
}
