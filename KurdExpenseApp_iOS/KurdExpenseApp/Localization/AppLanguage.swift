import SwiftUI

// ==========================================
// 🌍 MULTI-LANGUAGE & LOCALIZATION (SWIFT)
// ==========================================

public enum AppLanguage: String, CaseIterable, Codable {
    case kurdish = "KU"
    case english = "EN"
    case arabic  = "AR"

    public var title: String {
        switch self {
        case .kurdish: return "کوردی (سۆرانی)"
        case .english: return "English (US)"
        case .arabic:  return "العربية"
        }
    }

    public var layoutDirection: LayoutDirection {
        switch self {
        case .kurdish, .arabic: return .rightToLeft
        case .english:          return .leftToRight
        }
    }
}

public struct LStr {
    public let ku: String
    public let en: String
    public let ar: String

    public func text(for lang: AppLanguage) -> String {
        switch lang {
        case .kurdish: return ku
        case .english: return en
        case .arabic:  return ar
        }
    }
}

public struct Txt {
    public static let appName = LStr(ku: "خەرجیی کورد", en: "Kurd Expense", ar: "مصاريف كورد")
    public static let appTagline = LStr(ku: "بەڕێوەبردنی زیرەکانەی دارایی و پارەی تۆ", en: "Smart Kurdish Personal Finance & Expense Tracker", ar: "إدارة المصاريف المالية بذكاء وأمان")
    
    // Tabs
    public static let dashboard = LStr(ku: "سەرەکی", en: "Dashboard", ar: "الرئيسية")
    public static let records = LStr(ku: "تۆمارەکان", en: "Records", ar: "السجلات")
    public static let analytics = LStr(ku: "شیکاری", en: "Analytics", ar: "التحليلات")
    public static let settings = LStr(ku: "ڕێکخستن", en: "Settings", ar: "الإعدادات")

    // Dashboard
    public static let cloudSynced = LStr(ku: "کلاود چالاکە", en: "Cloud Synced", ar: "سحابي متصل")
    public static let totalBalance = LStr(ku: "کۆی باڵانسی بەردەست", en: "Total Available Balance", ar: "إجمالي الرصيد المتوفر")
    public static let totalIncome = LStr(ku: "کۆی داهات", en: "Total Income", ar: "إجمالي الدخل")
    public static let totalExpense = LStr(ku: "کۆی خەرجی", en: "Total Expense", ar: "إجمالي المصروفات")
    public static let addIncome = LStr(ku: "زیادکردنی داهات", en: "Add Income", ar: "إضافة دخل")
    public static let addExpense = LStr(ku: "زیادکردنی خەرجی", en: "Add Expense", ar: "إضافة مصروف")
    public static let recentTx = LStr(ku: "دواین جووڵە داراییەکان", en: "Recent Transactions", ar: "أحدث المعاملات")
    public static let viewAll = LStr(ku: "هەمووی ببینە", en: "View All", ar: "عرض الكل")
    public static let noTx = LStr(ku: "هیچ تۆمارێک نییە", en: "No transactions found", ar: "لا توجد معاملات")
    public static let noTxDesc = LStr(ku: "هێشتا هیچ داتایەکت لەم هەژمارە تۆمار نەکردووە، بە دوگمەی خوارەوە یەکەم تۆمار بنووسە", en: "Your database is clean. Tap below to record your first transaction.", ar: "قاعدة البيانات فارغة. اضغط أدناه لإضافة أول معاملة.")

    // Fields & Actions
    public static let title = LStr(ku: "ناونیشانی مامەڵە", en: "Transaction Title", ar: "عنوان المعاملة")
    public static let amount = LStr(ku: "بڕی پارە", en: "Amount", ar: "المبلغ")
    public static let category = LStr(ku: "پۆل / بەش", en: "Category", ar: "الفئة")
    public static let note = LStr(ku: "تێبینی (ئارەزوومەندانە)", en: "Note (Optional)", ar: "ملاحظة (اختياري)")
    public static let save = LStr(ku: "پاشەکەوتکردن لە کلاود", en: "Save to Cloud", ar: "حفظ في السحابة")
    public static let cancel = LStr(ku: "داخستن", en: "Cancel", ar: "إلغاء")
    public static let delete = LStr(ku: "سڕینەوە", en: "Delete", ar: "حذف")
    public static let quickAmounts = LStr(ku: "بڕی خێرا (دینار)", en: "Quick Amounts (IQD)", ar: "مبالغ سريعة (دينار)")
    public static let currencyUnit = "IQD"
    public static let currencySymbol = "د.ع"
    public static let confirmDelete = LStr(ku: "ئایا دڵنیایت لە سڕینەوەی ئەم تۆمارە لە داتابەیس؟", en: "Are you sure you want to delete this record?", ar: "هل أنت متأكد من حذف هذه المعاملة؟")

    // Filter
    public static let all = LStr(ku: "هەمووی", en: "All", ar: "الكل")
    public static let incomeOnly = LStr(ku: "داهاتەکان", en: "Income", ar: "الدخل")
    public static let expenseOnly = LStr(ku: "خەرجییەکان", en: "Expenses", ar: "المصروفات")
    public static let searchPlaceholder = LStr(ku: "گەڕان لە ناونیشان یان پۆل...", en: "Search title or category...", ar: "البحث في العنوان أو الفئة...")

    // Analytics
    public static let savingsRate = LStr(ku: "ڕێژەی پاشەکەوت", en: "Savings Rate", ar: "معدل الادخار")
    public static let monthlyAnalytics = LStr(ku: "بەراوردی مانگانەی داهات و خەرجی", en: "Monthly Comparison", ar: "مقارنة شهرية")
    public static let categoryBreakdown = LStr(ku: "دابەشبوونی خەرجییەکان بەپێی پۆل", en: "Category Breakdown", ar: "توزيع المصروفات حسب الفئة")
    public static let topCategory = LStr(ku: "زۆرترین بەشی خەرجی", en: "Top Spending Category", ar: "أعلى فئة صرف")

    // Auth
    public static let login = LStr(ku: "چوونەژوورەوە", en: "Sign In", ar: "تسجيل الدخول")
    public static let register = LStr(ku: "دروستکردنی هەژمار", en: "Create Account", ar: "إنشاء حساب جديد")
    public static let emailLabel = LStr(ku: "ئیمەیڵ", en: "Email Address", ar: "البريد الإلكتروني")
    public static let passwordLabel = LStr(ku: "تێپەڕەوشە (پاسۆرد)", en: "Password", ar: "كلمة المرور")
    public static let confirmPasswordLabel = LStr(ku: "دووبارەکردنەوەی تێپەڕەوشە", en: "Confirm Password", ar: "تأكيد كلمة المرور")
    public static let fullNameLabel = LStr(ku: "ناوی تەواو", en: "Full Name", ar: "الاسم الكامل")
    public static let guestMode = LStr(ku: "بەردەوامبوون وەک میوان", en: "Continue as Guest", ar: "المتابعة كضيف")
    public static let forgotPassword = LStr(ku: "تێپەڕەوشەت بیرچووە؟", en: "Forgot Password?", ar: "نسيت كلمة المرور؟")
    public static let resetPassTitle = LStr(ku: "نوێکردنەوەی تێپەڕەوشە", en: "Reset Password", ar: "إعادة تعيين كلمة المرور")
    public static let resetPassDesc = LStr(ku: "ئیمەیڵەکەت بنووسە بۆ ناردنی لینکی نوێکردنەوەی پاسۆرد", en: "Enter your email to receive a reset link.", ar: "أدخل بريدك الإلكتروني لإرسال رابط التعيين.")
    public static let sendLink = LStr(ku: "ناردنی لینک", en: "Send Link", ar: "إرسال الرابط")
    public static let resetSent = LStr(ku: "لینکی نوێکردنەوە بۆ ئیمەیڵەکەت نێردرا", en: "Reset link sent to your email", ar: "تم إرسال رابط التعيين")
    public static let signOut = LStr(ku: "چوونەدەرەوە لە هەژمار", en: "Sign Out", ar: "تسجيل الخروج")
    public static let confirmSignOut = LStr(ku: "ئایا دڵنیایت دەتەوێت لە هەژمارەکەت بچیتەدەرەوە؟", en: "Are you sure you want to sign out?", ar: "هل أنت متأكد من تسجيل الخروج؟")

    // Settings
    public static let profileTitle = LStr(ku: "پڕۆفایلی بەکارهێنەر", en: "User Profile", ar: "الملف الشخصي")
    public static let isolatedDataTitle = LStr(ku: "پاراستنی تایبەتمەندی و داتا", en: "Private & Isolated Cloud Storage", ar: "حماية الخصوصية والبيانات")
    public static let isolatedDataDesc = LStr(ku: "هەموو جووڵە داراییەکانت بە تەواوی بە شێوەیەکی پارێزراو و تایبەت پاشەکەوت دەبن و کەس ناتوانێت دەستی پێیان بگات.", en: "All your financial records are strictly protected and isolated to your account.", ar: "جميع معاملاتك المالية مشفرة وخاصة بحسابك فقط ولا يمكن لأحد الوصول إليها.")
    public static let languageTitle = LStr(ku: "زمانی بەرنامە", en: "Application Language", ar: "لغة التطبيق")
    public static let currencyTitle = LStr(ku: "دراوی بەکارهاتوو", en: "Currency", ar: "العملة المستخدمة")
    public static let currencyDesc = LStr(ku: "دیناری عێراقی (IQD)", en: "Iraqi Dinar (IQD)", ar: "الدينار العراقي (IQD)")
    public static let cloudSecurityTitle = LStr(ku: "سێرڤەری هەوری و پاراستن", en: "Secure Cloud Server", ar: "السيرفر السحابي الآمن")
    public static let cloudSecurityStatus = LStr(ku: "هەموو داتاکان بە ئۆنلاین پارێزراون", en: "Cloud Synchronization Active", ar: "المزامنة السحابية نشطة")
    public static let appVersionTitle = LStr(ku: "وەشانی بەرنامە", en: "App Version", ar: "إصدار التطبيق")
}

// Number & Date Formatting Helper
public struct KurdFormatter {
    public static func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
    }

    public static func formatDate(_ timestampMs: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestampMs) / 1000.0)
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy • hh:mm a"
        return df.string(from: date)
    }
}
