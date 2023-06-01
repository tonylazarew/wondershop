//
//  ProductStore.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

protocol ProductStore {
    /// Fetches the initial page of product list from the backend storage
    ///
    /// - Returns: An array of `Product` instances representing the initial page of data
    func fetch() async throws -> [Product]

    /// Fetches another product list page from the backend storage after a given product
    ///
    /// - Parameters:
    ///   - product: The `Product` object to start from.
    ///
    /// - Returns: An array of `Product` instances representing the subsequent page of data
    func fetch(after product: Product) async throws -> [Product]

    /// Fetches a single product information.
    ///
    /// - Returns: A `Product` instance for a given `id`.
    func fetch(id: Product.ID) async throws -> Product
}
