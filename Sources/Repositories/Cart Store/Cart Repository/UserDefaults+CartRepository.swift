//
//  UserDefaults+CartRepository.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

extension UserDefaults: CartRepository {

    private enum Keys {
        static let cart = "cart"
    }

    func getData() -> Data? {
        data(forKey: Keys.cart)
    }

    func setData(_ value: Data) {
        set(value, forKey: Keys.cart)
    }

    func remove() {
        removeObject(forKey: Keys.cart)
    }

}
