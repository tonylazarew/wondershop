//
//  CurrencyNumberFormatter.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

extension NumberFormatter {

    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

}

extension NumberFormatter {

    static let floatingPointSingle: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

}
