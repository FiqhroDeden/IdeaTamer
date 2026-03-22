import SwiftUI

// MARK: - Brand Font Styles

enum BrandFontStyle {
    case display    // 800, 28pt
    case headline   // 700, 18pt
    case title      // 700, 14pt
    case body       // 400, 13pt
    case label      // 700, 10pt
    case caption    // 400, 11pt
}

extension Font {
    static func brand(_ style: BrandFontStyle) -> Font {
        switch style {
        case .display:
            .custom("PlusJakartaSans-ExtraBold", size: 28)
        case .headline:
            .custom("PlusJakartaSans-Bold", size: 18)
        case .title:
            .custom("PlusJakartaSans-Bold", size: 14)
        case .body:
            .custom("PlusJakartaSans-Regular", size: 13)
        case .label:
            .custom("PlusJakartaSans-Bold", size: 10)
        case .caption:
            .custom("PlusJakartaSans-Regular", size: 11)
        }
    }
}
