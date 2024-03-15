//
//  Theme.swift
//  Memorize Game
//
//  Created by Matthew Braniff on 3/13/24.
//

import Foundation

enum ThemeEnum: String, CaseIterable {
    case smileTheme = "Smilies"
    case spookeyTheme = "Spooky"
    case spaceTheme = "Space"
    
    var theme: [String] {
        switch self {
        case .smileTheme:
            return .smileTheme
        case .spookeyTheme:
            return .spookyTheme
        case .spaceTheme:
            return .spaceTheme
        }
    }
}

class Theme: ObservableObject {
    @Published var currentTheme: [String] = .smileTheme
}

extension [String] {
    static let spookyTheme: Self = ["👻", "🧟", "😈", "🧛🏻‍♀️", "🎃"]
    static let smileTheme: Self = ["😁", "😇", "🙃", "🥰", "🥳"]
    static let spaceTheme: Self = ["🧑🏻‍🚀", "🪐", "🚀", "👽", "🛰️"]
}


