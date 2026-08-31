import SwiftUI

// ========================================================
// 📱 MAIN TAB & SHELL NAVIGATION (SWIFTUI)
// ========================================================

public struct MainTabView: View {
    @EnvironmentObject var repo: FirebaseExpenseRepository
    @Binding public var lang: AppLanguage

    @State private var selectedTab: Int = 0
    @State private var sheetTxType: TxType? = nil
    @State private var viewingTx: Transaction? = nil
    @State private var showSignOutAlert: Bool = false

    public var body: some View {
        VStack(spacing: 0) {
            // 1. Kurdish Top Bar
            topBarView

            // 2. Tab Navigation
            TabView(selection: $selectedTab) {
                // Tab 0: Dashboard
                KurdishDashboardView(
                    lang: lang,
                    onAddTransaction: { type in sheetTxType = type },
                    onViewAll: { selectedTab = 1 },
                    onSelectTransaction: { tx in viewingTx = tx }
                )
                .tabItem {
                    Label(Txt.dashboard.text(for: lang), systemImage: "house.fill")
                }
                .tag(0)

                // Tab 1: Records
                KurdishRecordsView(
                    lang: lang,
                    onSelectTransaction: { tx in viewingTx = tx }
                )
                .tabItem {
                    Label(Txt.records.text(for: lang), systemImage: "list.bullet.rectangle.portrait.fill")
                }
                .tag(1)

                // Tab 2: Analytics
                KurdishAnalyticsView(lang: lang)
                    .tabItem {
                        Label(Txt.analytics.text(for: lang), systemImage: "chart.pie.fill")
                    }
                    .tag(2)

                // Tab 3: Settings
                KurdishSettingsView(lang: $lang)
                    .tabItem {
                        Label(Txt.settings.text(for: lang), systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
            .tint(KurdColors.goldPrimary)
        }
        .sheet(item: Binding<IdentifiableTxType?>(
            get: { sheetTxType.map { IdentifiableTxType(type: $0) } },
            set: { sheetTxType = $0?.type }
        )) { item in
            KurdishAddTransactionSheet(initialType: item.type, lang: lang)
                .environmentObject(repo)
        }
        .sheet(item: $viewingTx) { tx in
            KurdishTransactionDetailSheet(transaction: tx, lang: lang)
                .environmentObject(repo)
        }
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

    // MARK: - 🔝 Kurdish Top Bar
    private var topBarView: some View {
        HStack(spacing: 12) {
            // Sign Out / Exit Icon Button
            Button {
                showSignOutAlert = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 40, height: 40)
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(KurdColors.sunYellow)
                }
            }

            // Cloud Status Pill
            HStack(spacing: 6) {
                Circle()
                    .fill(repo.isCloudSynced ? KurdColors.zagrosEmerald : KurdColors.pomegranateRed)
                    .frame(width: 7, height: 7)

                Text(Txt.cloudSynced.text(for: lang))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.08))
            .clipShape(Capsule())

            Spacer()

            // Currency Badge & Title
            HStack(spacing: 8) {
                Text("IQD")
                    .font(.system(size: 11, weight: .black))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(KurdColors.goldPrimary.opacity(0.2))
                    .foregroundColor(KurdColors.goldPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .trailing, spacing: 1) {
                    Text(Txt.appName.text(for: lang))
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(.white)

                    Text(currentTabSubtitle)
                        .font(.system(size: 11))
                        .foregroundColor(KurdColors.textMuted)
                }

                // 21-ray Sun Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 40, height: 40)
                    KurdishSunIconView(size: 24)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(KurdColors.midnightNavy)
    }

    private var currentTabSubtitle: String {
        switch selectedTab {
        case 0: return Txt.dashboard.text(for: lang)
        case 1: return Txt.records.text(for: lang)
        case 2: return Txt.analytics.text(for: lang)
        case 3: return Txt.settings.text(for: lang)
        default: return ""
        }
    }
}

// Helper wrapper for Sheet presentation
struct IdentifiableTxType: Identifiable {
    let id = UUID()
    let type: TxType
}
