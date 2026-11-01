import SwiftUI

enum BEYONDTheme {
    enum Colors {
        static let accent = Color.accentColor
        static let secondaryText = Color.secondary
        static let surface = Color(uiColor: .secondarySystemBackground)
    }

    enum Spacing {
        static let compact: CGFloat = 8
        static let standard: CGFloat = 16
        static let spacious: CGFloat = 24
        static let large: CGFloat = 32
    }

    enum Radius {
        static let card: CGFloat = 18
        static let capsule: CGFloat = 999
    }
}
