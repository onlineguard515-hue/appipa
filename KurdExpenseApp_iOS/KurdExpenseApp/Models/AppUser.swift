import Foundation

// ==========================================
// 👤 APP USER PROFILE MODEL (SWIFT)
// ==========================================

public struct AppUser: Codable, Equatable, Identifiable {
    public var id: String { uid }
    public let uid: String
    public var displayName: String
    public var email: String
    public var isGuest: Bool

    public init(uid: String, displayName: String, email: String, isGuest: Bool = false) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.isGuest = isGuest
    }
}
