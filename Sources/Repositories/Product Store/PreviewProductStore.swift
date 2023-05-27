//
//  PreviewProductStore.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

#if DEBUG

final class PreviewProductStore: ProductStore {
    // MARK: - Types

    enum PreviewError: Error {
        case unsupported
    }

    enum Behaviour {
        case normal
        case loadFromJSON

        case failing
        case failThenSucceed
    }

    // MARK: - Initialization

    private let behaviour: Behaviour
    private var callCount = 0

    init(behaviour: Behaviour = .normal) {
        self.behaviour = behaviour
    }

    // MARK: - ProductStore

    func fetch() async throws -> [Product] {
        switch behaviour {
        case .normal:
            return Product.previews
        case .loadFromJSON:
            let fileURL = Bundle.main.url(forResource: "dummyjson-products", withExtension: "json")!

            let data = try! Data(contentsOf: fileURL)

            return try! JSONDecoder().decode(DummyJSONProductData.self, from: data).products
        case .failing:
            throw PreviewError.unsupported
        case .failThenSucceed:
            if callCount == 0 {
                callCount += 1
                throw PreviewError.unsupported
            } else {
                return Product.previews
            }
        }
    }

    func fetch(after _: Product) async throws -> [Product] {
        throw PreviewError.unsupported
    }
}

#endif
