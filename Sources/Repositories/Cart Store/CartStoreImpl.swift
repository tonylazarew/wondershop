//
//  UserDefaults+CartStore.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

final class CartStoreImpl: CartStore {
    private let repository: CartRepository

    // MARK: - Initialization

    init(repository: CartRepository) {
        self.repository = repository
    }

    // MARK: - CartStore

    var currentCart: Cart {
        get async {
            let data = repository.getData()

            guard let data else {
                return [:]
            }

            do {
                return try JSONDecoder().decode(Cart.self, from: data)
            } catch {
                return [:]
            }
        }
    }

    func updateCurrentCart(_ cart: Cart) async {
        do {
            let data = try JSONEncoder().encode(cart)
            repository.setData(data)
        } catch {
            // Ungraceful fallback
            repository.remove()
        }
    }
}
