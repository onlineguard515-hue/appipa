import SwiftUI

// ==========================================
// ☀️ 21-RAY KURDISH SUN VECTOR SHAPE (SWIFTUI)
// ==========================================
public struct KurdishSunShape: Shape {
    public let rayCount: Int = 21

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let centerRadius = min(rect.width, rect.height) * 0.22
        let innerRayRadius = min(rect.width, rect.height) * 0.28
        let outerRayRadius = min(rect.width, rect.height) * 0.48
        
        // 1. Center Sun Core Circle
        path.addEllipse(in: CGRect(
            x: center.x - centerRadius,
            y: center.y - centerRadius,
            width: centerRadius * 2,
            height: centerRadius * 2
        ))
        
        // 2. 21 Rays Triangles
        let angleStep = (2.0 * .pi) / Double(rayCount)
        let halfBaseAngle = angleStep * 0.28
        
        for i in 0..<rayCount {
            let angle = Double(i) * angleStep - (.pi / 2.0)
            let tipX = center.x + CGFloat(cos(angle)) * outerRayRadius
            let tipY = center.y + CGFloat(sin(angle)) * outerRayRadius
            
            let b1X = center.x + CGFloat(cos(angle - halfBaseAngle)) * innerRayRadius
            let b1Y = center.y + CGFloat(sin(angle - halfBaseAngle)) * innerRayRadius
            
            let b2X = center.x + CGFloat(cos(angle + halfBaseAngle)) * innerRayRadius
            let b2Y = center.y + CGFloat(sin(angle + halfBaseAngle)) * innerRayRadius
            
            path.move(to: CGPoint(x: tipX, y: tipY))
            path.addLine(to: CGPoint(x: b1X, y: b1Y))
            path.addLine(to: CGPoint(x: b2X, y: b2Y))
            path.closeSubpath()
        }
        
        return path
    }
}

// Reusable View with Glow Effect
public struct KurdishSunIconView: View {
    public var size: CGFloat = 36
    public var color: Color = KurdColors.sunYellow
    public var glow: Color = KurdColors.goldLight

    public init(size: CGFloat = 36, color: Color = KurdColors.sunYellow, glow: Color = KurdColors.goldLight) {
        self.size = size
        self.color = color
        self.glow = glow
    }

    public var body: some View {
        ZStack {
            // Subtle Radial Glow
            Circle()
                .fill(glow.opacity(0.25))
                .frame(width: size * 1.3, height: size * 1.3)
                .blur(radius: 4)

            // Vector Sun
            KurdishSunShape()
                .fill(
                    LinearGradient(
                        colors: [color, KurdColors.goldPrimary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
        }
    }
}
