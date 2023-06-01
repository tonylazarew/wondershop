//
//  ProductDescriptionViewModel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

extension URL: Identifiable {
    public var id: Int {
        hashValue
    }
}

@MainActor
final class ProductDescriptionViewModel: ObservableObject {
    // MARK: - Properties

    var title: String {
        product.title
    }

    var brand: String {
        product.brand
    }

    var description: String {
        product.description
    }

    var category: String {
        "Category: \(product.category)"
    }

    var stock: String {
        "\(product.stock) left in stock"
    }

    var ratingStars: Int {
        Int(product.rating)
    }

    var rating: String {
        let value = NumberFormatter.floatingPointSingle.string(from: NSNumber(value: product.rating))

        guard let value else {
            return "\(product.rating)"
        }

        return value
    }

    var price: String {
        var value: String?

        value = NumberFormatter.currency.string(
            from: NSNumber(value: product.discountedPrice ?? product.price)
        )

        guard let value else {
            return "\(product.discountedPrice ?? product.price)"
        }

        return value
    }

    var imageURLs: [URL] {
        product.imagesURLs.compactMap { $0 }
    }

    @Published var isInCart: Bool = false

    // MARK: - Internal

    private let product: Product
    private let cartManager: CartManager

    private func setupBindings() {
        cartManager.streamUpdates(for: product)
            .map { $0 > 0 }
            .assign(to: &$isInCart)
    }

    // MARK: - Initialization

    init(
        product: Product,
        cartManager: CartManager
    ) {
        self.product = product
        self.cartManager = cartManager

        setupBindings()
    }

    // MARK: - Public

    func addToCartButtonPressed() async {
        await cartManager.toggle(product)
    }
}

extension ProductDescriptionViewModel: Hashable, Equatable {
    static func == (lhs: ProductDescriptionViewModel, rhs: ProductDescriptionViewModel) -> Bool {
        lhs.product.id == rhs.product.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(product.id)
    }
}
