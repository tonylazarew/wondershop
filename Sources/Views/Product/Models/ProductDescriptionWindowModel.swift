//
//  ProductDescriptionWindowModel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 01/06/2023.
//

import Combine

@MainActor
final class ProductDescriptionWindowModel: ObservableObject {
    // MARK: - Internal

    private let productStore: ProductStore
    private let cartManager: CartManager
    private let productId: Product.ID

    // MARK: - State

    enum State {
        case loading
        case failure(message: String)
        case data(ProductDescriptionViewModel)
    }

    // MARK: - Properties

    @Published private(set) var state: State = .loading

    // MARK: - Initialization

    init(
        productStore: ProductStore,
        cartManager: CartManager,
        id: Product.ID
    ) {
        self.productStore = productStore
        self.cartManager = cartManager
        productId = id
    }
}

extension ProductDescriptionWindowModel {
    // MARK: - Public

    func start() async {
        do {
            let product = try await productStore.fetch(id: productId)

            state = .data(.init(product: product, cartManager: cartManager))
        } catch {
            state = .failure(message: "Failed to fetch product data")
        }
    }
}

#if DEBUG

extension ProductDescriptionWindowModel {
    static let preview = ProductDescriptionWindowModel(
        productStore: .preview,
        cartManager: previewCartManager(),
        id: Product.preview.id
    )
}

#endif
