import SwiftUI

// ========================================================
// 🔐 ULTRA-PREMIUM KURDISH AUTH / LOGIN VIEW (SWIFTUI)
// ========================================================

public struct KurdishAuthView: View {
    @EnvironmentObject var repo: FirebaseExpenseRepository
    @Binding public var lang: AppLanguage

    @State private var isRegister: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var fullName: String = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showResetSheet: Bool = false
    @State private var resetEmail: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var resetSuccessMsg: String? = nil

    public var body: some View {
        ZStack {
            // Midnight Luxury Background
            KurdColors.midnightNavy
                .ignoresSafeArea()

            // Glowing Watermark Sun in Background
            VStack {
                KurdishSunShape()
                    .fill(KurdColors.sunYellow.opacity(0.04))
                    .frame(width: 400, height: 400)
                    .offset(y: -40)
                Spacer()
            }
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // 1. Language Picker Pill & Kurdish Sun Badge Header
                    HStack {
                        // Language Selector
                        HStack(spacing: 4) {
                            ForEach(AppLanguage.allCases, id: \.self) { l in
                                Button {
                                    withAnimation { lang = l }
                                } label: {
                                    Text(l == .kurdish ? "کورد" : l.rawValue)
                                        .font(.system(size: 12, weight: .bold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(lang == l ? KurdColors.goldPrimary : Color.white.opacity(0.1))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())

                        Spacer()

                        // Brand Badge
                        HStack(spacing: 6) {
                            KurdishSunIconView(size: 16)
                            Text("Kurd Expense")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(KurdColors.goldPrimary.opacity(0.3), lineWidth: 1))
                    }
                    .padding(.top, 10)

                    // 2. Kurdish Sun Core Emblem
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(KurdColors.goldPrimary.opacity(0.15))
                                .frame(width: 90, height: 90)
                                .blur(radius: 8)

                            Circle()
                                .stroke(KurdColors.goldPrimary, lineWidth: 2)
                                .frame(width: 76, height: 76)

                            KurdishSunIconView(size: 48)
                        }

                        Text(Txt.appName.text(for: lang))
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.white)

                        Text(Txt.appTagline.text(for: lang))
                            .font(.system(size: 13))
                            .foregroundColor(KurdColors.textMuted)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 8)

                    // 3. Main Auth Card
                    VStack(spacing: 20) {
                        // Segmented Switcher (Login / Register)
                        HStack(spacing: 0) {
                            Button {
                                withAnimation(.spring()) {
                                    isRegister = false
                                    errorMessage = nil
                                }
                            } label: {
                                Text(Txt.login.text(for: lang))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(!isRegister ? .white : KurdColors.textMuted)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(!isRegister ? KurdColors.midnightNavy : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            Button {
                                withAnimation(.spring()) {
                                    isRegister = true
                                    errorMessage = nil
                                }
                            } label: {
                                Text(Txt.register.text(for: lang))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(isRegister ? .white : KurdColors.textMuted)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(isRegister ? KurdColors.midnightNavy : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(4)
                        .background(Color(hex: 0xF1F5F9))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // Error Banner if any
                        if let error = errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // Fields
                        VStack(spacing: 14) {
                            if isRegister {
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundColor(KurdColors.textMuted)
                                    TextField(Txt.fullNameLabel.text(for: lang), text: $fullName)
                                }
                                .padding()
                                .background(Color(hex: 0xF8FAFC))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(KurdColors.borderSubtle, lineWidth: 1))
                            }

                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(KurdColors.textMuted)
                                TextField(Txt.emailLabel.text(for: lang), text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(Color(hex: 0xF8FAFC))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(KurdColors.borderSubtle, lineWidth: 1))

                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(KurdColors.textMuted)
                                if showPassword {
                                    TextField(Txt.passwordLabel.text(for: lang), text: $password)
                                } else {
                                    SecureField(Txt.passwordLabel.text(for: lang), text: $password)
                                }
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(KurdColors.textMuted)
                                }
                            }
                            .padding()
                            .background(Color(hex: 0xF8FAFC))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(KurdColors.borderSubtle, lineWidth: 1))

                            if isRegister {
                                HStack {
                                    Image(systemName: "lock.shield")
                                        .foregroundColor(KurdColors.textMuted)
                                    if showConfirmPassword {
                                        TextField(Txt.confirmPasswordLabel.text(for: lang), text: $confirmPassword)
                                    } else {
                                        SecureField(Txt.confirmPasswordLabel.text(for: lang), text: $confirmPassword)
                                    }
                                    Button {
                                        showConfirmPassword.toggle()
                                    } label: {
                                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                            .foregroundColor(KurdColors.textMuted)
                                    }
                                }
                                .padding()
                                .background(Color(hex: 0xF8FAFC))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(KurdColors.borderSubtle, lineWidth: 1))
                            }
                        }

                        // Forgot Password Link
                        if !isRegister {
                            HStack {
                                Button(Txt.forgotPassword.text(for: lang)) {
                                    resetEmail = email
                                    showResetSheet = true
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(KurdColors.goldPrimary)
                                Spacer()
                            }
                        }

                        // Primary Action Button (Sign In / Register)
                        Button {
                            handleAuthAction()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: isRegister ? "person.badge.plus" : "arrow.right.circle.fill")
                                    Text(isRegister ? Txt.register.text(for: lang) : Txt.login.text(for: lang))
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(KurdColors.midnightNavy)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(isLoading)

                        // Divider OR
                        HStack {
                            Rectangle().fill(KurdColors.borderSubtle).frame(height: 1)
                            Text("یان / OR")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(KurdColors.textMuted)
                                .padding(.horizontal, 8)
                            Rectangle().fill(KurdColors.borderSubtle).frame(height: 1)
                        }

                        // Continue as Guest Button
                        Button {
                            isLoading = true
                            repo.signInAsGuest { success, err in
                                isLoading = false
                                if let err = err { errorMessage = err }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(KurdColors.goldPrimary)
                                Text(Txt.guestMode.text(for: lang))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(KurdColors.midnightNavy)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(KurdColors.borderSubtle, lineWidth: 1.2))
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: Color.black.opacity(0.15), radius: 20, y: 10)

                    // 4. Privacy Guarantee Footer
                    HStack(spacing: 12) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 24))
                            .foregroundColor(KurdColors.zagrosEmerald)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(Txt.isolatedDataTitle.text(for: lang))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)

                            Text(Txt.isolatedDataDesc.text(for: lang))
                                .font(.system(size: 11))
                                .foregroundColor(KurdColors.textMuted)
                                .lineLimit(2)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showResetSheet) {
            resetPasswordSheet
        }
        .environment(\.layoutDirection, lang.layoutDirection)
    }

    private func handleAuthAction() {
        errorMessage = nil
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "تکایە ئیمەیڵ و وشەی نهێنی بنووسە"
            return
        }

        if isRegister {
            if password != confirmPassword {
                errorMessage = "تێپەڕەوشەکان لە یەک ناچن"
                return
            }
            if password.count < 6 {
                errorMessage = "وشەی نهێنی پێویستە بەلایەنی کەم ٦ پیت یان ژمارە بێت"
                return
            }
            isLoading = true
            repo.signUp(name: fullName, email: email, pass: password) { success, err in
                isLoading = false
                if let err = err { errorMessage = err }
            }
        } else {
            isLoading = true
            repo.signIn(email: email, pass: password) { success, err in
                isLoading = false
                if let err = err { errorMessage = err }
            }
        }
    }

    private var resetPasswordSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(Txt.resetPassDesc.text(for: lang))
                    .font(.system(size: 14))
                    .foregroundColor(KurdColors.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                TextField(Txt.emailLabel.text(for: lang), text: $resetEmail)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(KurdColors.borderSubtle, lineWidth: 1))

                if let success = resetSuccessMsg {
                    Text(success)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(KurdColors.zagrosEmerald)
                }

                Button {
                    guard !resetEmail.isEmpty else { return }
                    repo.resetPassword(email: resetEmail) { success, err in
                        if success {
                            resetSuccessMsg = Txt.resetSent.text(for: lang)
                        } else if let err = err {
                            errorMessage = err
                        }
                    }
                } label: {
                    Text(Txt.sendLink.text(for: lang))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KurdColors.midnightNavy)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()
            }
            .padding()
            .background(KurdColors.backgroundSoft)
            .navigationTitle(Txt.resetPassTitle.text(for: lang))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Txt.cancel.text(for: lang)) {
                        showResetSheet = false
                    }
                }
            }
        }
    }
}
