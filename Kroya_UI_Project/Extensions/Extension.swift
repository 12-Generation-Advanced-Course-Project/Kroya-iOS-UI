//
//  StringExtension.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//
import SwiftUI
import Foundation
import UIKit
extension String {
    // MARK: Validate if string is a valid email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

// MARK: Custom Fonts Inter for English
enum Inter: String {
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semibold = "Inter-SemiBold"
    case black = "Inter-Black"
    case bold = "Inter-Bold"
    case light = "Inter-Light"
}

extension Font {
    static func customfont(_ font: Inter, fontSize: CGFloat) -> Font {
        custom(font.rawValue, size: fontSize)
    }
}

//// MARK: Custom Fonts KantumruyPro for Khmer
//enum KantumryPro: String {
//    case regular = "KantumruyPro-Regular"
//    case medium = "KantumruyPro-Medium"
//    case semibold = "KantumruyPro-SemiBold"
//    case bold = "KantumruyPro-Bold"
//    case light = "KantumruyPro-Light"
//}
//
//extension Font {
//    static func fontKm(_ font: KantumryPro, fontSize: CGFloat) -> Font {
//        custom(font.rawValue, size: fontSize)
//    }
//}
//
//// MARK: Custom Fonts NotoSansKR for Korean
//enum NotoSansKR: String {
//    case black = "NotoSansKR-Black"
//    case regular = "NotoSansKR-Regular"
//    case medium = "NotoSansKR-Medium"
//    case semibold = "NotoSansKR-SemiBold"
//    case bold = "NotoSansKR-Bold"
//    case light = "NotoSansKR-Light"
//}
//
//extension Font {
//    static func fontkR(_ font: NotoSansKR, fontSize: CGFloat) -> Font {
//        custom(font.rawValue, size: fontSize)
//    }
//}

//extension Font {
//    static func customfont(_ font: KantumryPro, fontSize: CGFloat) -> Font {
//        custom(font.rawValue, size: fontSize)
//    }
//}


//func fontForCurrentLocale() -> Font {
//    let locale = Locale.current.identifier
//    
//    if locale.starts(with: "km") { // Khmer
//        return Font.custom("KantumruyPro-VariableFont_wght", size: 16)
//    } else if locale.starts(with: "ko") { // Korean
//        return Font.custom("NotoSansKR-VariableFont_wght", size: 16)
//    } else { // Default to English
//        return Font.custom("Inter-Italic-VariableFont_opsz,wght", size: 16)
//    }
//}

//MARK: Using CGFloat For Responsive Screen
extension CGFloat {
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }
}

//MARK: Converting Color Hex Code
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB(12 -bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

//MARK: Custom Shape to handle rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}




//MARK: Using For Save Image
extension View {
    func captureUIView(size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let controller = UIHostingController(rootView: self)  // Capture current view (self)
        let hostingView = controller.view

        // Set the desired frame to match the size of the content you want to capture
        hostingView?.frame = CGRect(origin: .zero, size: size)

        // Render the view into a UIImage
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            hostingView?.drawHierarchy(in: hostingView!.bounds, afterScreenUpdates: true)
        }

        completion(image)
    }
}


// MARK: Using for Native Navigation Swap
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct NavigationControllerWrapper<Content: View>: UIViewControllerRepresentable {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let hostingController = UIHostingController(rootView: content)
        let navigationController = UINavigationController(rootViewController: hostingController)
        navigationController.navigationBar.isTranslucent = true // Make the navigation bar translucent
        navigationController.navigationBar.isUserInteractionEnabled = false
        navigationController.navigationBar.isHidden = true
        
        hostingController.view.backgroundColor = .clear // Ensure the background is clear to avoid white space issues
        

        
        navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let hostingController = uiViewController.viewControllers.first as? UIHostingController<Content> {
            hostingController.rootView = content
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
//MARK: Alert Saving Food Draft
struct AlertControllerWrapper: UIViewControllerRepresentable {
    let draftModel: DraftModel
    let dismiss: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // Placeholder view controller for presenting the alert
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard uiViewController.presentedViewController == nil else { return }
        
        let alert = UIAlertController(title: "Save this as a draft?",
                                      message: "If you choose to discard, your data will be lost.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save Draft", style: .default) { _ in
            // Save data and dismiss
            dismiss()
        })
        
        alert.addAction(UIAlertAction(title: "Discard Post", style: .destructive) { _ in
            draftModel.clearDraft() // Clear the draft
            dismiss()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        uiViewController.present(alert, animated: true, completion: nil)
    }
}

//Change fonts base on Language

struct CustomFontLocalization: ViewModifier {
    var size: CGFloat
    @Environment(\.locale) var local
    
    func body(content: Content) -> some View {
        content
            .font(.custom(local.identifier == "km" ? "KantumruyPro-Regular" : local.identifier == "en" ? "Inter-Regular" : "NotoSansKR-Regular", size: size))
    }
}

struct CustomFontMediumLocalization: ViewModifier {
    var size: CGFloat
    @Environment(\.locale) var local
    func body(content: Content) -> some View {
        content
            .font(.custom(local.identifier == "km" ? "KantumruyPro-Medium" : local.identifier == "en" ? "Inter-Medium" : "NotoSansKR-Medium", size: size))
    }
}

struct CustomFontSemiblodLocalization: ViewModifier {
    var size: CGFloat
    @Environment(\.locale) var local
    func body(content: Content) -> some View {
        content
            .font(.custom(local.identifier == "km" ? "KantumruyPro-SemiBold" : local.identifier == "en" ? "Inter-Medium" : "NotoSansKR-SemiBold", size: size))
    }
}

struct CustomFontBoldLocalization: ViewModifier {
    var size: CGFloat
    @Environment(\.locale) var local
    func body(content: Content) -> some View {
        content
            .font(.custom(local.identifier == "km-KH" ? "KantumruyPro-Bold" : local.identifier == "en" ? "Inter-Bold" : "NotoSansKR-Bold", size: size))
    }
}

struct CustomFontModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter-Regular", size: size))
    }
}

struct CustomFontMediumModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter-Medium", size: size))
    }
}

struct CustomFontBoldModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter-Black", size: size))
    }
}

extension View {
    func customFont(size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(size: size))
    }
    func customFontMedium(size: CGFloat) -> some View {
        self.modifier(CustomFontMediumModifier(size: size))
    }
    func customFontBold(size: CGFloat) -> some View {
        self.modifier(CustomFontBoldModifier(size: size))
    }
    func customFontLocalize(size: CGFloat) -> some View {
        self.modifier(CustomFontLocalization(size: size))
    }
    func customFontMediumLocalize(size: CGFloat) -> some View {
        self.modifier(CustomFontMediumLocalization(size: size))
    }
    func customFontSemiBoldLocalize(size: CGFloat) -> some View {
        self.modifier(CustomFontSemiblodLocalization(size: size))
    }
    func customFontBoldLocalize(size: CGFloat) -> some View {
        self.modifier(CustomFontBoldLocalization(size: size))
    }
    
}
