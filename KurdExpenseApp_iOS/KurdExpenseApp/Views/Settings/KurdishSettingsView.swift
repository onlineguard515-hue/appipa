import SwiftUI

// ========================================================
// ⚙️ SETTINGS & PRIVACY GUARANTEE VIEW (SWIFTUI)
// ========================================================

public struct KurdishSettingsView: View {
    @EnvironmentObject var repo: FirebaseExpenseRepository
    @Binding public var lang: AppLanguage

    @State private var showSignOutAlert: Bool = false

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 1. User Profile Card
                userProfileCard

                // 2. Privacy & Data Isolation Guarantee
                privacyGuaranteeCard

                // 3. Cloud Security & App Version Card (Clean, Consumer Friendly)
                cloudSecurityCard

                // 4. Language Selector Card
                languageSelectorCard

                // 5. Currency Card
                currencyCard

                // 6. Sign Out Button
                signOutButton
            }
            .padding(16)
        }
        .background(KurdColors.backgroundSoft)
        .confirmationDialog(
            Txt.confirmSignOut.text(for: lang),
            isPresented: $showSignOutAlert,
            titleVisibility: .visible
        ) {
            Button(Txt.signOut.text(for: lang), role: .destructive) {
                repo.signOut()
            }
            Button(Txt.cancel.text(for: lang), role: .cancel) { }
        }
        .environment(\.layoutDirection, lang.layoutDirection)
    }

    // MARK: - 👤 Profile Card
    private var userProfileCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(KurdColors.midnightNavy)
                        .frame(width: 56, height: 56)

                    let firstChar = String(repo.currentUser?.displayName.prefix(1) ?? "K")
                    Text(firstChar)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(KurdColors.sunYellow)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(repo.currentUser?.displayName ?? "User")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)

                    Text(repo.currentUser?.email ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(KurdColors.textMuted)
                }

                Spacer()
            }

            Divider()

            HStack {
                Text("کۆی تۆمارەکان لە کلاود")
                    .font(.system(size: 13))
                    .foregroundColor(KurdColors.textMuted)
                Spacer()
                Text("\(repo.transactions.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(KurdColors.midnightNavy)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))
    }

    // MARK: - 🛡️ Privacy Guarantee Card
    private var privacyGuaranteeCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 28))
                .foregroundColor(KurdColors.zagrosEmerald)

            VStack(alignment: .leading, spacing: 4) {
                Text(Txt.isolatedDataTitle.text(for: lang))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(KurdColors.zagrosEmerald)

                Text(Txt.isolatedDataDesc.text(for: lang))
                    .font(.system(size: 12))
                    .foregroundColor(KurdColors.slateLight)
                    .lineSpacing(2)
            }
        }
        .padding(18)
        .background(KurdColors.zagrosSoft)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(KurdColors.zagrosEmerald.opacity(0.3), lineWidth: 1))
    }

    // MARK: - ☁️ Cloud Security Card
    private var cloudSecurityCard: some View {
        VStack(spacing: 14) {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(KurdColors.zagrosSoft)
                            .frame(width: 40, height: 40)
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(KurdColors.zagrosEmerald)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(Txt.cloudSecurityTitle.text(for: lang))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)
                        Text(Txt.cloudSecurityStatus.text(for: lang))
                            .font(.system(size: 12))
                            .foregroundColor(KurdColors.textMuted)
                    }
                }

                Spacer()

                Text("Active")
                    .font(.system(size: 11, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(KurdColors.zagrosEmerald.opacity(0.12))
                    .foregroundColor(KurdColors.zagrosEmerald)
                    .clipShape(Capsule())
            }

            Divider()

            HStack {
                Text(Txt.appVersionTitle.text(for: lang))
                    .font(.system(size: 12))
                    .foregroundColor(KurdColors.textMuted)
                Spacer()
                Text("v1.0.0 (Kurdish Edition)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(KurdColors.midnightNavy)
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))
    }

    // MARK: - 🌐 Language Selector
    private var languageSelectorCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(KurdColors.goldPrimary)
                Text(Txt.languageTitle.text(for: lang))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(KurdColors.midnightNavy)
            }

            VStack(spacing: 8) {
                ForEach(AppLanguage.allCases, id: \.self) { l in
                    let isSelected = l == lang
                    Button {
                        withAnimation { lang = l }
                    } label: {
                        HStack {
                            Text(l.title)
                                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? KurdColors.midnightNavy : KurdColors.textMuted)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(KurdColors.goldPrimary)
                            }
                        }
                        .padding(12)
                        .background(isSelected ? KurdColors.goldGlow.opacity(0.5) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? KurdColors.goldLight : Color.clear, lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))
    }

    // MARK: - 💰 Currency Card
    private var currencyCard: some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(KurdColors.zagrosSoft)
                        .frame(width: 40, height: 40)
                    Text("IQD")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(KurdColors.zagrosEmerald)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(Txt.currencyTitle.text(for: lang))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)
                    Text(Txt.currencyDesc.text(for: lang))
                        .font(.system(size: 12))
                        .foregroundColor(KurdColors.textMuted)
                }
            }

            Spacer()

            Text("د.ع")
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(KurdColors.goldPrimary.opacity(0.15))
                .foregroundColor(KurdColors.goldPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))
    }

    // MARK: - 🚪 Sign Out Button
    private var signOutButton: some View {
        Button {
            showSignOutAlert = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text(Txt.signOut.text(for: lang))
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(KurdColors.pomegranateRed)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(KurdColors.redSoft)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(KurdColors.redLight.opacity(0.3), lineWidth: 1))
        }
    }
}
