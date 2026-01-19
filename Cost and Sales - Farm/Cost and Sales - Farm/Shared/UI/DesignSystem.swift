import SwiftUI
import UIKit
import CoreText

struct DesignSystem {
    struct Colors {
        static let background = Color(hex: "03050F")
        
        static let cardBackground = Color.white.opacity(0.08)
        static let itemInnerBackground = Color.black.opacity(0.4)
        
        static let tabBackground = Color(red: 0.20, green: 0.15, blue: 0.25).opacity(0.60)
        static let tabActive = Color(red: 1, green: 0.84, blue: 0).opacity(0.50) // Желтый акцент
        static let tabInactive = Color(red: 0.58, green: 0.67, blue: 0.87)
        
        static let inputFieldBackground = Color(red: 0.48, green: 0.47, blue: 0.67).opacity(0.3)
        static let pickerBackground = Color(red: 0.15, green: 0.15, blue: 0.3)
        static let orangeBorder = Color(red: 1, green: 0.84, blue: 0) // Желтый акцент
        
        static let incomeYellow = Color(red: 1, green: 0.84, blue: 0) // Желтый акцент
        static let accentBlue = Color(hex: "00A3FF")
        static let accentYellow = Color(red: 1, green: 0.84, blue: 0) // Желтый акцент
        static let expenseRed = Color(red: 0.93, green: 0.08, blue: 0.06)
        static let green = Color(hex: "34C759")
        
        static let white = Color.white
        static let grey = Color(hex: "94A3B8")
        static let lightGrey = Color.white.opacity(0.85)
        static let mutedWhite = Color.white.opacity(0.35)
        
        static let chartBlue = Color(red: 0.35, green: 0.41, blue: 0.81)
        static let chartLightBlue = Color(red: 0.52, green: 0.58, blue: 0.93)
        static let chartPink = Color(red: 1, green: 0.51, blue: 0.77)
        static let chartPurple = Color(red: 0.79, green: 0.51, blue: 1)
        static let chartCyan = Color(red: 0.35, green: 0.91, blue: 1)
        
        static let buttonBackground = Color(hex: "FBFCFE")
        static let buttonBorder = Color(hex: "DDE4F0")
        static let buttonText = Color(hex: "667AC2")
    }
    
    struct Gradients {
        static func mainBackground() -> some View {
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
        
        static func splashBackground() -> some View {
            ZStack {
                Image("AppIcon") // Используем иконку как фон
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 50)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image("AppIcon")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .cornerRadius(28)
                    
                    ProgressView()
                        .tint(.white)
                }
            }
        }
    }
    
    struct Effects {
        static func glassMaterial() -> some View {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .opacity(0.25)
                .overlay(DesignSystem.Colors.cardBackground)
        }
    }
    
    struct Typography {
        static func poppins(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            let fontName: String
            switch weight {
            case .bold: fontName = "Poppins-Bold"
            case .semibold: fontName = "Poppins-SemiBold"
            case .medium: fontName = "Poppins-Medium"
            default: fontName = "Poppins-Regular"
            }
            return .custom(fontName, size: size)
        }
        static func header(_ size: CGFloat = 24) -> Font { poppins(size, weight: .semibold) }
        static func medium(_ size: CGFloat = 16) -> Font { poppins(size, weight: .medium) }
        static func body(_ size: CGFloat = 16) -> Font { poppins(size, weight: .regular) }
    }

    static func registerFonts() {
        let fonts = [
            "Poppins-Bold.ttf",
            "Poppins-SemiBold.ttf",
            "Poppins-Medium.ttf",
            "Poppins-Regular.ttf"
        ]
        
        for font in fonts {
            let url = Bundle.main.url(forResource: font, withExtension: nil) ?? 
                      Bundle.main.url(forResource: font, withExtension: nil, subdirectory: "Resources/Fonts")
            
            guard let fontUrl = url else {
                print("Font not found: \(font)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(fontUrl as CFURL, .process, &error) {
                print("Error registering font: \(error?.takeRetainedValue().localizedDescription ?? "unknown error")")
            }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView(effect: effect) }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { uiView.effect = effect }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
