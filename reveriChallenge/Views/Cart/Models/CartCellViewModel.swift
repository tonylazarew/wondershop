//
//  CartCellViewModel.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

@MainActor
final class CartCellViewModel: ObservableObject, Identifiable {

    // MARK: - Properties

    nonisolated var id: Int {
        product.id
    }

    var title: String {
        product.title
    }

    var brand: String {
        product.brand
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

    var thumbnailURL: URL? {
        product.thumbnailURL
    }

    @Published var amount: Int = 0

    let descriptionViewModel: ProductDescriptionViewModel

    // MARK: - Internal

    private let product: Product
    private let cartManager: CartManager

    private func setupBindings()  {
        cartManager.streamUpdates(for: product)
            .assign(to: &$amount)
    }

    // MARK: - Initialization

    init(
        product: Product,
        cartManager: CartManager,
        descriptionViewModel: ProductDescriptionViewModel
    ) {
        self.product = product
        self.cartManager = cartManager
        self.descriptionViewModel = descriptionViewModel

        setupBindings()
    }

    // MARK: - Public

    func increaseButtonPressed() async {
        await cartManager.add(product)
    }

    func decreaseButtonPressed() async {
        await cartManager.remove(product)
    }
}
