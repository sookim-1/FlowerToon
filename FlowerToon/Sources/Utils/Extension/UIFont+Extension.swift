//
//  UIFont+Extension.swift
//  FlowerToon
//
//  Created by sookim on 3/2/25.
//  Copyright © 2025 sookim-1. All rights reserved.
//

import UIKit

extension UIFont {

    public enum PretendardType: String {
        case bold = "Bold"
        case semiBold = "SemiBold"
        case medium = "Medium"
        case regular = "Regular"
        case light = "Light"
        case extraLight = "ExtraLight"
        case thin = "Thin"
    }

    static func pretendard(_ type: PretendardType, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Pretendard-\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}

