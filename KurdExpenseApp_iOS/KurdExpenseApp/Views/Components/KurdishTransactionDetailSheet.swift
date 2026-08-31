import SwiftUI

// ========================================================
// 🔍 TRANSACTION DETAILS MODAL SHEET (SWIFTUI)
// ========================================================

public struct KurdishTransactionDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var repo: FirebaseExpenseRepository

    public let transaction: Transaction
    public let lang: AppLanguage

    @State private var showDeleteConfirm: Bool = false

    private var category: AppCategory {
        AppCategories.find(byName: transaction.category)
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Category Icon Badge & Type
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(category.color.opacity(0.15))
                            .frame(width: 72, height: 72)

                        Image(systemName: category.iconSystemName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(category.color)
                    }

                    Text(transaction.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(KurdColors.midnightNavy)

                    // Amount
                    HStack(spacing: 4) {
                        Text("\(transaction.type.isIncome ? "+" : "−") \(KurdFormatter.formatAmount(transaction.amount))")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(transaction.type.isIncome ? KurdColors.zagrosEmerald : KurdColors.pomegranateRed)

                        Text(Txt.currencyUnit)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(KurdColors.textMuted)
                    }
                }
                .padding(.top, 20)

                // Info Cards List
                VStack(spacing: 12) {
                    // Category Row
                    HStack {
                        Label(Txt.category.text(for: lang), systemImage: "square.grid.2x2")
                            .foregroundColor(KurdColors.textMuted)
                            .font(.system(size: 14))
                        Spacer()
                        Text(transaction.category)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(KurdColors.midnightNavy)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Date & Time Row
                    HStack {
                        Label("بەروار و کات", systemImage: "clock")
                            .foregroundColor(KurdColors.textMuted)
                            .font(.system(size: 14))
                        Spacer()
                        Text(KurdFormatter.formatDate(transaction.date))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(KurdColors.midnightNavy)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Note Row if available
                    if !transaction.note.isEmpty {
                        HStack(alignment: .top) {
                            Label(Txt.note.text(for: lang), systemImage: "note.text")
                                .foregroundColor(KurdColors.textMuted)
                                .font(.system(size: 14))
                            Spacer()
                            Text(transaction.note)
                                .font(.system(size: 14))
                                .foregroundColor(KurdColors.midnightNavy)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }

                Spacer()

                // Delete Button
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text(Txt.delete.text(for: lang))
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(KurdColors.pomegranateRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(KurdColors.redSoft)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(KurdColors.redLight.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding()
            .background(KurdColors.backgroundSoft)
            .navigationTitle(Txt.category.text(for: lang))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Txt.cancel.text(for: lang)) {
                        dismiss()
                    }
                }
            }
            .confirmationDialog(
                Txt.confirmDelete.text(for: lang),
                isPresented: $showDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button(Txt.delete.text(for: lang), role: .destructive) {
                    repo.deleteTransaction(id: transaction.id)
                    dismiss()
                }
                Button(Txt.cancel.text(for: lang), role: .cancel) { }
            }
            .environment(\.layoutDirection, lang.layoutDirection)
        }
    }
}
