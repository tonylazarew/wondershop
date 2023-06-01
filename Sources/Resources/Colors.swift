//
//  Colors.swift
//  Wondershop
//
//  Created by Anton Lazarev on 29/05/2023.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS)

extension UIColor {
    static var accentColor: UIColor {
        if let color = UIColor(named: "AccentColor") {
            return color
        } else {
            return .systemOrange
        }
    }
}

#elseif os(macOS)

extension NSColor {
    static var accentColor: NSColor {
        if let color = NSColor(named: "AccentColor") {
            return color
        } else {
            return .systemOrange
        }
    }
}

#endif
