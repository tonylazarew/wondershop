//
//  DummyJSONProductStore.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

final class DummyJSONProductStore: ProductStore {

    // MARK: - Types

    enum Const {
        static let limit = 10
    }

    // MARK: - Properties

    private let baseURL: URL

    // MARK: - Initialization

    init(
        baseURL: URL = Configuration.dummyJSONURL
    ) {
        self.baseURL = baseURL
    }

    // MARK: - Private

    private func fetch(afterId id: Int?) async throws -> [Product] {
        var queryItems: [URLQueryItem] = [
            .init(name: "limit", value: "\(Const.limit)"),
        ]

        if let id {
            queryItems.append(
                .init(name: "skip", value: "\(id)")
            )
        }

        let url = baseURL
            .appending(path: "products")
            .appending(queryItems: queryItems)

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(DummyJSONProductData.self, from: data).products
    }

    // MARK: - ProductStore

    func fetch() async throws -> [Product] {
        try await fetch(afterId: nil)
    }

    func fetch(after product: Product) async throws -> [Product] {
        try await fetch(afterId: product.id)
    }

}
