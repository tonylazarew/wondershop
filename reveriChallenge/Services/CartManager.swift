//
//  CartManager.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine

protocol CartStateReadable {

    /// Returns a stream of updates for a given product, whether the product is in the cart or not
    func streamUpdates(for product: Product) -> AnyPublisher<ProductAmount, Never>

    var amount: AnyPublisher<Int, Never> { get }
    var allItems: AnyPublisher<Cart, Never> { get }

}

protocol CartStateWriteable {

    /// Adds a product to the cart.
    ///
    /// If the product already is in the cart then increment its quantity.
    func add(_ product: Product) async

    /// Removes a single entity of the product from the cart.
    func remove(_ product: Product) async

    /// Drops a product from the cart completely.
    func drop(_ product: Product) async

    /// Either adds or drops a product from the cart.
    func toggle(_ product: Product) async

}

typealias CartManager = CartStateReadable & CartStateWriteable
