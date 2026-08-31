import SwiftUI

// ========================================================
// 📊 KURDISH DASHBOARD VIEW (SWIFTUI)
// ========================================================

public struct KurdishDashboardView: View {
    @EnvironmentObject var repo: FirebaseExpenseRepository
    public var lang: AppLanguage
    public var onAddTransaction: (TxType) -> Void
    public var onViewAll: () -> Void
    public var onSelectTransaction: (Transaction) -> Void

    private var income: Double {
        repo.transactions.filter { $0.type.isIncome }.reduce(0) { $0 + $1.amount }
    }

    private var expense: Double {
        repo.transactions.filter { !$0.type.isIncome }.reduce(0) { $0 + $1.amount }
    }

    private var balance: Double {
        income - expense
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. User Greeting Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        let name = repo.currentUser?.displayName.isEmpty == false ? repo.currentUser!.displayName : (repo.currentUser?.isGuest == true ? "میوان / Guest" : "هاوڕێ")
                        Text("\(lang == .kurdish ? "سڵاو،" : (lang == .arabic ? "مرحباً،" : "Hello,")) \(name) 👋")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(KurdColors.midnightNavy)

                        Text(Txt.appTagline.text(for: lang))
                            .font(.system(size: 12))
                            .foregroundColor(KurdColors.textMuted)
                    }
                    Spacer()
                }
                .padding(.horizontal, 4)

                // 2. Kurdish Hero Balance Card
                heroBalanceCard

                // 3. Quick Action Buttons (Income & Expense)
                HStack(spacing: 12) {
                    // Add Income Card Button
                    Button {
                        onAddTransaction(.income)
                    } label: {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle().fill(KurdColors.zagrosEmerald.opacity(0.2)).frame(width: 36, height: 36)
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(KurdColors.zagrosEmerald)
                            }
                            Text(Txt.addIncome.text(for: lang))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(KurdColors.zagrosEmerald)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KurdColors.zagrosSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(KurdColors.zagrosEmerald.opacity(0.3), lineWidth: 1))
                    }

                    // Add Expense Card Button
                    Button {
                        onAddTransaction(.expense)
                    } label: {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle().fill(KurdColors.pomegranateRed.opacity(0.2)).frame(width: 36, height: 36)
                                Image(systemName: "minus")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(KurdColors.pomegranateRed)
                            }
                            Text(Txt.addExpense.text(for: lang))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(KurdColors.pomegranateRed)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KurdColors.redSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(KurdColors.pomegranateRed.opacity(0.3), lineWidth: 1))
                    }
                }

                // 4. Recent Transactions Section
                VStack(spacing: 12) {
                    HStack {
                        Text(Txt.recentTx.text(for: lang))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)

                        Spacer()

                        if !repo.transactions.isEmpty {
                            Button(Txt.viewAll.text(for: lang)) {
                                onViewAll()
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KurdColors.goldPrimary)
                        }
                    }

                    if repo.transactions.isEmpty {
                        // Empty State
                        emptyStateView
                    } else {
                        // Transaction Cards List
                        VStack(spacing: 10) {
                            ForEach(Array(repo.transactions.prefix(6))) { tx in
                                transactionRow(tx)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(KurdColors.backgroundSoft)
        .environment(\.layoutDirection, lang.layoutDirection)
    }

    // MARK: - 👑 Hero Balance Card
    private var heroBalanceCard: some View {
        ZStack {
            // Background & Radial Glow
            RoundedRectangle(cornerRadius: 24)
                .fill(KurdColors.heroGradient)

            // Sun Watermark
            HStack {
                KurdishSunShape()
                    .fill(KurdColors.sunYellow.opacity(0.06))
                    .frame(width: 220, height: 220)
                    .offset(x: -30, y: -20)
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))

            VStack(spacing: 18) {
                // Top Balance Tag
                HStack {
                    HStack(spacing: 6) {
                        Circle().fill(KurdColors.sunYellow).frame(width: 8, height: 8)
                        Text(Txt.totalBalance.text(for: lang))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.85))
                    }
                    Spacer()
                }

                // Balance Number
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(KurdFormatter.formatAmount(balance))
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(.white)

                    Text(Txt.currencyUnit)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(KurdColors.sunYellow)

                    Spacer()
                }

                // Income / Expense Stats Pills
                HStack(spacing: 12) {
                    // Expense Box
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(Txt.totalExpense.text(for: lang))
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.7))
                            Text("−\(KurdFormatter.formatAmount(expense))")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(KurdColors.pomegranateRed)
                            .font(.system(size: 20))
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Income Box
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(Txt.totalIncome.text(for: lang))
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.7))
                            Text("+\(KurdFormatter.formatAmount(income))")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(KurdColors.zagrosEmerald)
                            .font(.system(size: 20))
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(20)
        }
        .shadow(color: KurdColors.midnightNavy.opacity(0.2), radius: 12, y: 6)
    }

    // MARK: - 📭 Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle().fill(KurdColors.goldGlow).frame(width: 64, height: 64)
                KurdishSunIconView(size: 34)
            }

            Text(Txt.noTx.text(for: lang))
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(KurdColors.midnightNavy)

            Text(Txt.noTxDesc.text(for: lang))
                .font(.system(size: 13))
                .foregroundColor(KurdColors.textMuted)
                .multilineTextAlignment(.center)

            Button {
                onAddTransaction(.expense)
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text(Txt.addExpense.text(for: lang))
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(KurdColors.midnightNavy)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 6)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))
    }

    // MARK: - 🧾 Transaction Row Card
    private func transactionRow(_ tx: Transaction) -> some View {
        let cat = AppCategories.find(byName: tx.category)
        return Button {
            onSelectTransaction(tx)
        } label: {
            HStack(spacing: 12) {
                // Category Icon
                ZStack {
                    Circle()
                        .fill(cat.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: cat.iconSystemName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(cat.color)
                }

                // Title & Category
                VStack(alignment: .leading, spacing: 2) {
                    Text(tx.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)
                    Text(tx.category)
                        .font(.system(size: 12))
                        .foregroundColor(KurdColors.textMuted)
                }

                Spacer()

                // Amount
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(tx.type.isIncome ? "+" : "−") \(KurdFormatter.formatAmount(tx.amount))")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(tx.type.isIncome ? KurdColors.zagrosEmerald : KurdColors.pomegranateRed)

                    Text(Txt.currencyUnit)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(KurdColors.textMuted)
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(KurdColors.borderSubtle, lineWidth: 1))
        }
    }
}
