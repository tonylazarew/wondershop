//
//  CartManagerImpl.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine
import Foundation

final class CartManagerImpl {

    private var cart: Cart = [:]
    private let store: CartStore

    // MARK: - Initialization

    init(
        store: CartStore
    ) {
        self.store = store
    }

    // MARK: - Internal

    private var updated = CurrentValueSubject<Bool, Never>(true)

    private func syncStorage() async {
        await store.updateCurrentCart(cart)
    }

    // MARK: - Public

    func loadFromStore() async {
        cart = await store.currentCart
        updated.send(true)
    }

}

extension CartManagerImpl: CartStateReadable {

    var amount: AnyPublisher<Int, Never> {
        updated
            .map { [weak self] _ in
                self?.cart.values
                    .reduce(0) { $0 + $1 }
                ?? 0
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var allItems: AnyPublisher<Cart, Never> {
        updated
            .map { [weak self] _ -> Cart in
                self?.cart ?? [:]
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func streamUpdates(for product: Product) -> AnyPublisher<ProductAmount, Never> {
        updated
            .map { [weak self] _ in
                self?.cart[product] ?? 0
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

extension CartManagerImpl: CartStateWriteable {

    func add(_ product: Product) async {
        if let productAmount = cart[product] {
            // Make sure to not overbook the stock
            if productAmount < product.stock {
                cart.updateValue(productAmount + 1, forKey: product)
            }
        } else {
            cart[product] = 1
        }

        await syncStorage()
        updated.send(true)
    }

    func remove(_ product: Product) async {
        if let productAmount = cart[product] {
            if productAmount > 1 {
                cart.updateValue(productAmount - 1, forKey: product)
            } else {
                await drop(product)
            }
        }

        await syncStorage()
        updated.send(true)
    }

    func drop(_ product: Product) async {
        cart.removeValue(forKey: product)

        await syncStorage()
        updated.send(true)
    }

    func toggle(_ product: Product) async {
        if cart.keys.contains(product) {
            await drop(product)
        } else {
            await add(product)
        }
    }

}
