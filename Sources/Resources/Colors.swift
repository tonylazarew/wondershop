//
//  Colors.swift
//  Wondershop
//
//  Created by Anton Lazarev on 29/05/2023.
//

import UIKit

extension UIColor {
    static var accentColor: UIColor {
        if let color = UIColor(named: "AccentColor") {
            return color
        } else {
            return .systemOrange
        }
    }
}
