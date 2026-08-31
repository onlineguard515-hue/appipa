import SwiftUI

// ========================================================
// 📋 RECORDS & TRANSACTIONS VIEW (SWIFTUI)
// ========================================================

public struct KurdishRecordsView: View {
    @EnvironmentObject var repo: FirebaseExpenseRepository
    public var lang: AppLanguage
    public var onSelectTransaction: (Transaction) -> Void

    @State private var searchText: String = ""
    @State private var selectedFilter: FilterType = .all

    enum FilterType: CaseIterable {
        case all, income, expense

        func title(for lang: AppLanguage) -> String {
            switch self {
            case .all: return Txt.all.text(for: lang)
            case .income: return Txt.incomeOnly.text(for: lang)
            case .expense: return Txt.expenseOnly.text(for: lang)
            }
        }
    }

    private var filteredTransactions: [Transaction] {
        repo.transactions.filter { tx in
            let matchesFilter: Bool
            switch selectedFilter {
            case .all: matchesFilter = true
            case .income: matchesFilter = tx.type.isIncome
            case .expense: matchesFilter = !tx.type.isIncome
            }

            let matchesSearch: Bool
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                matchesSearch = true
            } else {
                let query = searchText.lowercased()
                matchesSearch = tx.title.lowercased().contains(query) || tx.category.lowercased().contains(query)
            }

            return matchesFilter && matchesSearch
        }
    }

    public var body: some View {
        VStack(spacing: 14) {
            // 1. Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(KurdColors.textMuted)

                TextField(Txt.searchPlaceholder.text(for: lang), text: $searchText)
                    .font(.system(size: 14))

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(KurdColors.textMuted)
                    }
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(KurdColors.borderSubtle, lineWidth: 1))
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // 2. Filter Segment Chips & Count
            HStack {
                HStack(spacing: 8) {
                    ForEach(FilterType.allCases, id: \.self) { f in
                        let isSelected = f == selectedFilter
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedFilter = f
                            }
                        } label: {
                            Text(f.title(for: lang))
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(isSelected ? KurdColors.midnightNavy : Color.white)
                                .foregroundColor(isSelected ? .white : KurdColors.midnightNavy)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(isSelected ? Color.clear : KurdColors.borderSubtle, lineWidth: 1))
                        }
                    }
                }

                Spacer()

                // Count Badge
                Text("\(filteredTransactions.count)")
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(KurdColors.goldGlow)
                    .foregroundColor(KurdColors.goldPrimary)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)

            // 3. Transactions List
            if filteredTransactions.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(KurdColors.textMuted)
                    Text(Txt.noTx.text(for: lang))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)
                }
                Spacer()
            } else {
                List {
                    ForEach(filteredTransactions) { tx in
                        let cat = AppCategories.find(byName: tx.category)
                        Button {
                            onSelectTransaction(tx)
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(cat.color.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: cat.iconSystemName)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(cat.color)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(tx.title)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(KurdColors.midnightNavy)

                                    HStack(spacing: 6) {
                                        Text(tx.category)
                                            .font(.system(size: 12))
                                            .foregroundColor(KurdColors.textMuted)
                                        Text("•")
                                            .font(.system(size: 10))
                                            .foregroundColor(KurdColors.textMuted)
                                        Text(KurdFormatter.formatDate(tx.date))
                                            .font(.system(size: 11))
                                            .foregroundColor(KurdColors.textMuted)
                                    }
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(tx.type.isIncome ? "+" : "−") \(KurdFormatter.formatAmount(tx.amount))")
                                        .font(.system(size: 15, weight: .black))
                                        .foregroundColor(tx.type.isIncome ? KurdColors.zagrosEmerald : KurdColors.pomegranateRed)

                                    Text(Txt.currencyUnit)
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(KurdColors.textMuted)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                repo.deleteTransaction(id: tx.id)
                            } label: {
                                Label(Txt.delete.text(for: lang), systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
        .background(KurdColors.backgroundSoft)
        .environment(\.layoutDirection, lang.layoutDirection)
    }
}
