import Foundation
import SwiftUI

// ==========================================
// 💸 TRANSACTION MODEL & TYPES (SWIFT)
// ==========================================

public enum TxType: String, Codable, CaseIterable {
    case income = "INCOME"
    case expense = "EXPENSE"
    
    public var isIncome: Bool { self == .income }
}

public struct Transaction: Identifiable, Codable, Equatable {
    public let id: String
    public var title: String
    public var category: String
    public var amount: Double
    public var type: TxType
    public var date: Int64
    public var note: String
    public var userId: String

    public init(
        id: String = UUID().uuidString,
        title: String,
        category: String,
        amount: Double,
        type: TxType,
        date: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        note: String = "",
        userId: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.amount = amount
        self.type = type
        self.date = date
        self.note = note
        self.userId = userId
    }
}

// Category Definition
public struct AppCategory: Identifiable, Hashable {
    public let id = UUID()
    public let nameKu: String
    public let nameEn: String
    public let nameAr: String
    public let iconSystemName: String
    public let color: Color

    public func localizedName(for lang: AppLanguage) -> String {
        switch lang {
        case .kurdish: return nameKu
        case .english: return nameEn
        case .arabic:  return nameAr
        }
    }
}

public struct AppCategories {
    public static let all: [AppCategory] = [
        AppCategory(nameKu: "خواردن و چێشت", nameEn: "Food & Dining", nameAr: "طعام ومشروبات", iconSystemName: "fork.knife", color: Color(hex: 0xF59E0B)),
        AppCategory(nameKu: "هاتووچۆ و بەنزین", nameEn: "Transport & Fuel", nameAr: "مواصلات ووقود", iconSystemName: "car.fill", color: Color(hex: 0x3B82F6)),
        AppCategory(nameKu: "کرێ و ماڵ", nameEn: "Rent & Housing", nameAr: "إيجار وسكن", iconSystemName: "house.fill", color: Color(hex: 0x8B5CF6)),
        AppCategory(nameKu: "پسوولە و کارەبا", nameEn: "Bills & Utilities", nameAr: "فواتير وكهرباء", iconSystemName: "bolt.fill", color: Color(hex: 0xEC4899)),
        AppCategory(nameKu: "بازاڕکردن و جلوبەرگ", nameEn: "Shopping & Clothes", nameAr: "تسوق وملابس", iconSystemName: "bag.fill", color: Color(hex: 0x10B981)),
        AppCategory(nameKu: "تەندروستی و دەرمان", nameEn: "Health & Medical", nameAr: "صحة وعلاج", iconSystemName: "cross.case.fill", color: Color(hex: 0xEF4444)),
        AppCategory(nameKu: "مووچە و داهات", nameEn: "Salary & Income", nameAr: "راتب ودخل", iconSystemName: "banknote.fill", color: Color(hex: 0x059669)),
        AppCategory(nameKu: "دیاری و بەخشین", nameEn: "Gifts & Charity", nameAr: "هدايا وصدقات", iconSystemName: "gift.fill", color: Color(hex: 0xD97706)),
        AppCategory(nameKu: "پەروەردە و خوێندن", nameEn: "Education & Books", nameAr: "تعليم ودراسة", iconSystemName: "book.fill", color: Color(hex: 0x6366F1)),
        AppCategory(nameKu: "هیتر", nameEn: "Other", nameAr: "أخرى", iconSystemName: "ellipsis.circle.fill", color: Color(hex: 0x64748B))
    ]
    
    public static func find(byName name: String) -> AppCategory {
        all.first { $0.nameKu == name || $0.nameEn == name || $0.nameAr == name } ?? all.last!
    }
}
