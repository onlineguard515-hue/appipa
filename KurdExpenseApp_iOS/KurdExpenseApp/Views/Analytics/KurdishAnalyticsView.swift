import SwiftUI

// ========================================================
// 📈 ANALYTICS & INSIGHTS VIEW (SWIFTUI)
// ========================================================

public struct KurdishAnalyticsView: View {
    @EnvironmentObject var repo: FirebaseExpenseRepository
    public var lang: AppLanguage

    private var income: Double {
        repo.transactions.filter { $0.type.isIncome }.reduce(0) { $0 + $1.amount }
    }

    private var expense: Double {
        repo.transactions.filter { !$0.type.isIncome }.reduce(0) { $0 + $1.amount }
    }

    private var savingsRate: Int {
        guard income > 0 else { return 0 }
        let rate = ((income - expense) / income) * 100.0
        return max(0, min(100, Int(rate)))
    }

    // Category breakdown
    private var categoryExpenses: [(category: AppCategory, amount: Double, percent: Int)] {
        let expenseTxs = repo.transactions.filter { !$0.type.isIncome }
        guard expense > 0 else { return [] }

        var dict: [String: Double] = [:]
        for tx in expenseTxs {
            dict[tx.category, default: 0] += tx.amount
        }

        return dict.map { (catName, sum) in
            let cat = AppCategories.find(byName: catName)
            let pct = Int((sum / expense) * 100.0)
            return (category: cat, amount: sum, percent: pct)
        }.sorted { $0.amount > $1.amount }
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. Savings Rate KPI Card
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(Txt.savingsRate.text(for: lang))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KurdColors.textMuted)

                        Text("\(savingsRate)%")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(KurdColors.zagrosEmerald)

                        Text(savingsRate >= 20 ? "ئاستێکی زۆر باشە بۆ پاشەکەوت" : "هەوڵبدە خەرجییەکانت کەمبکەیتەوە")
                            .font(.system(size: 12))
                            .foregroundColor(KurdColors.textMuted)
                    }

                    Spacer()

                    // Circular Progress
                    ZStack {
                        Circle()
                            .stroke(KurdColors.zagrosEmerald.opacity(0.15), lineWidth: 8)
                            .frame(width: 74, height: 74)

                        Circle()
                            .trim(from: 0, to: CGFloat(savingsRate) / 100.0)
                            .stroke(
                                KurdColors.emeraldGradient,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 74, height: 74)
                            .rotationEffect(.degrees(-90))

                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(KurdColors.zagrosEmerald)
                            .font(.system(size: 24, weight: .bold))
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))

                // 2. Monthly Comparison Chart (Income vs Expense)
                VStack(alignment: .leading, spacing: 16) {
                    Text(Txt.monthlyAnalytics.text(for: lang))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)

                    let maxVal = max(income, expense, 1)

                    HStack(alignment: .bottom, spacing: 24) {
                        // Income Bar
                        VStack(spacing: 8) {
                            Text("+\(KurdFormatter.formatAmount(income))")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(KurdColors.zagrosEmerald)

                            RoundedRectangle(cornerRadius: 12)
                                .fill(KurdColors.emeraldGradient)
                                .frame(width: 48, height: CGFloat(income / maxVal) * 140 + 16)

                            Text(Txt.totalIncome.text(for: lang))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(KurdColors.midnightNavy)
                        }
                        .frame(maxWidth: .infinity)

                        // Expense Bar
                        VStack(spacing: 8) {
                            Text("−\(KurdFormatter.formatAmount(expense))")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(KurdColors.pomegranateRed)

                            RoundedRectangle(cornerRadius: 12)
                                .fill(KurdColors.redGradient)
                                .frame(width: 48, height: CGFloat(expense / maxVal) * 140 + 16)

                            Text(Txt.totalExpense.text(for: lang))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(KurdColors.midnightNavy)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))

                // 3. Category Breakdown
                VStack(alignment: .leading, spacing: 16) {
                    Text(Txt.categoryBreakdown.text(for: lang))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)

                    if categoryExpenses.isEmpty {
                        Text(Txt.noTx.text(for: lang))
                            .font(.system(size: 13))
                            .foregroundColor(KurdColors.textMuted)
                            .padding(.vertical, 10)
                    } else {
                        VStack(spacing: 14) {
                            ForEach(categoryExpenses, id: \.category.id) { item in
                                VStack(spacing: 6) {
                                    HStack {
                                        Image(systemName: item.category.iconSystemName)
                                            .foregroundColor(item.category.color)
                                        Text(item.category.localizedName(for: lang))
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(KurdColors.midnightNavy)
                                        Spacer()
                                        Text("\(KurdFormatter.formatAmount(item.amount)) \(Txt.currencyUnit)")
                                            .font(.system(size: 13, weight: .semibold))
                                        Text("(\(item.percent)%)")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(KurdColors.textMuted)
                                    }

                                    // Progress Bar
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color(hex: 0xF1F5F9))
                                                .frame(height: 8)

                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(item.category.color)
                                                .frame(width: geo.size.width * CGFloat(item.percent) / 100.0, height: 8)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(KurdColors.borderSubtle, lineWidth: 1))
            }
            .padding(16)
        }
        .background(KurdColors.backgroundSoft)
        .environment(\.layoutDirection, lang.layoutDirection)
    }
}
