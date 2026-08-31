import SwiftUI

// ========================================================
// ➕ ADD TRANSACTION SHEET MODAL (SWIFTUI)
// ========================================================

public struct KurdishAddTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var repo: FirebaseExpenseRepository

    public var initialType: TxType
    public var lang: AppLanguage

    @State private var type: TxType
    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var selectedCategory: AppCategory
    @State private var note: String = ""
    @State private var showError: Bool = false

    private let quickAmounts: [Double] = [5000, 10000, 25000, 50000, 100000]

    public init(initialType: TxType = .expense, lang: AppLanguage) {
        self.initialType = initialType
        self.lang = lang
        _type = State(initialValue: initialType)
        _selectedCategory = State(initialValue: AppCategories.all.first!)
    }

    private var activeColor: Color {
        type.isIncome ? KurdColors.zagrosEmerald : KurdColors.pomegranateRed
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Type Switcher Pill (Income / Expense)
                    HStack(spacing: 0) {
                        Button {
                            type = .expense
                        } label: {
                            Text(Txt.addExpense.text(for: lang))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(!type.isIncome ? .white : KurdColors.textMuted)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(!type.isIncome ? KurdColors.pomegranateRed : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Button {
                            type = .income
                        } label: {
                            Text(Txt.addIncome.text(for: lang))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(type.isIncome ? .white : KurdColors.textMuted)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(type.isIncome ? KurdColors.zagrosEmerald : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(4)
                    .background(Color(hex: 0xF1F5F9))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // 2. Amount Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Txt.amount.text(for: lang))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)

                        HStack {
                            TextField("0", text: $amountText)
                                .keyboardType(.numberPad)
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(activeColor)

                            Text(Txt.currencyUnit)
                                .font(.system(size: 13, weight: .bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(activeColor.opacity(0.12))
                                .foregroundColor(activeColor)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(showError && amountText.isEmpty ? Color.red : KurdColors.borderSubtle, lineWidth: 1)
                        )
                    }

                    // 3. Quick Amounts
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Txt.quickAmounts.text(for: lang))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(KurdColors.textMuted)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(quickAmounts, id: \.self) { val in
                                    Button {
                                        let current = Double(amountText.filter { "0123456789".contains($0) }) ?? 0
                                        amountText = String(format: "%.0f", current + val)
                                    } label: {
                                        Text("+\(KurdFormatter.formatAmount(val))")
                                            .font(.system(size: 12, weight: .bold))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(KurdColors.goldGlow)
                                            .foregroundColor(KurdColors.midnightNavy)
                                            .clipShape(Capsule())
                                            .overlay(Capsule().stroke(KurdColors.goldLight, lineWidth: 1))
                                    }
                                }
                            }
                        }
                    }

                    // 4. Title Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Txt.title.text(for: lang))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)

                        TextField(Txt.title.text(for: lang), text: $title)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(showError && title.isEmpty ? Color.red : KurdColors.borderSubtle, lineWidth: 1)
                            )
                    }

                    // 5. Category Selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Txt.category.text(for: lang))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(AppCategories.all) { cat in
                                    let isSelected = cat.id == selectedCategory.id
                                    Button {
                                        selectedCategory = cat
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: cat.iconSystemName)
                                            Text(cat.localizedName(for: lang))
                                        }
                                        .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(isSelected ? cat.color : Color.white)
                                        .foregroundColor(isSelected ? .white : KurdColors.midnightNavy)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(isSelected ? Color.clear : KurdColors.borderSubtle, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                    }

                    // 6. Note (Optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Txt.note.text(for: lang))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)

                        TextField(Txt.note.text(for: lang), text: $note)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(KurdColors.borderSubtle, lineWidth: 1)
                            )
                    }

                    Spacer().frame(height: 10)

                    // 7. Save Button
                    Button {
                        guard let amt = Double(amountText.replacingOccurrences(of: ",", with: "")), amt > 0, !title.isEmpty else {
                            showError = true
                            return
                        }
                        let newTx = Transaction(
                            title: title,
                            category: selectedCategory.localizedName(for: lang),
                            amount: amt,
                            type: type,
                            date: Int64(Date().timeIntervalSince1970 * 1000),
                            note: note,
                            userId: repo.currentUser?.uid ?? ""
                        )
                        repo.addTransaction(transaction: newTx)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(Txt.save.text(for: lang))
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(KurdColors.midnightNavy)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: KurdColors.midnightNavy.opacity(0.2), radius: 8, y: 4)
                    }
                }
                .padding()
            }
            .background(KurdColors.backgroundSoft)
            .navigationTitle(type.isIncome ? Txt.addIncome.text(for: lang) : Txt.addExpense.text(for: lang))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Txt.cancel.text(for: lang)) {
                        dismiss()
                    }
                    .foregroundColor(KurdColors.textMuted)
                }
            }
            .environment(\.layoutDirection, lang.layoutDirection)
        }
    }
}
