import SwiftUI

// ==========================================
// 🎨 KURDISH THEME COLOR PALETTE (SWIFTUI)
// ==========================================
public struct KurdColors {
    // Flag & National Accents
    public static let zagrosEmerald = Color(hex: 0x10B981)      // Green (داهات / Income)
    public static let zagrosSoft    = Color(hex: 0xECFDF5)
    public static let pomegranateRed = Color(hex: 0xEF4444)     // Red (خەرجی / Expense)
    public static let redSoft       = Color(hex: 0xFEF2F2)
    public static let redLight      = Color(hex: 0xFCA5A5)
    
    // Sun Gold & Sunlight
    public static let sunYellow     = Color(hex: 0xFBBF24)      // 21-ray Golden Sun
    public static let goldPrimary   = Color(hex: 0xF59E0B)
    public static let goldLight     = Color(hex: 0xFDE68A)
    public static let goldGlow      = Color(hex: 0xFEF3C7)
    
    // Midnight Luxury Slate / Dark Hero
    public static let midnightNavy  = Color(hex: 0x0F172A)
    public static let slateDark     = Color(hex: 0x1E293B)
    public static let slateCard     = Color(hex: 0x334155)
    public static let slateLight    = Color(hex: 0x64748B)
    
    // Backgrounds & Surfaces
    public static let backgroundSoft = Color(hex: 0xF8FAFC)     // Main Light Surface
    public static let cardBg         = Color.white
    public static let borderSubtle   = Color(hex: 0xE2E8F0)
    public static let textMuted      = Color(hex: 0x94A3B8)
    
    // Gradients
    public static let heroGradient = LinearGradient(
        colors: [Color(hex: 0x0F172A), Color(hex: 0x1E293B), Color(hex: 0x111827)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let goldGradient = LinearGradient(
        colors: [Color(hex: 0xF59E0B), Color(hex: 0xFBBF24)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let emeraldGradient = LinearGradient(
        colors: [Color(hex: 0x059669), Color(hex: 0x10B981)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let redGradient = LinearGradient(
        colors: [Color(hex: 0xDC2626), Color(hex: 0xEF4444)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// Extension to initialize Color from hex integer
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
