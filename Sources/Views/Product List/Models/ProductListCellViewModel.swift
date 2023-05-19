//
//  ProductListCellViewModel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine
import Foundation

@MainActor
final class ProductListCellViewModel: ObservableObject {

    // MARK: - Public properties

    var title: String {
        product.title
    }

    var brand: String {
        product.brand
    }

    var price: String {
        let value = NumberFormatter.currency.string(from: NSNumber(value: product.price))

        guard let value else {
            return "\(product.price)"
        }

        return value
    }

    var discountedPrice: String? {
        guard let discountedPrice = product.discountedPrice else {
            return nil
        }

        let value = NumberFormatter.currency.string(from: NSNumber(value: discountedPrice))

        guard let value else {
            return "\(discountedPrice)"
        }

        return value
    }

    var thumbnailURL: URL? {
        product.thumbnailURL
    }

    @Published var isInCart: Bool = false

    // MARK: - Internal

    private let product: Product
    private let cartManager: CartManager

    typealias OnAppearCallback = (_ product: Product) async -> Void
    private let onAppearCallback: OnAppearCallback

    private func setupBindings() {
        cartManager.streamUpdates(for: product)
            .map { $0 > 0 }
            .assign(to: &$isInCart)
    }

    // MARK: - Initialization

    init(
        product: Product,
        cartManager: CartManager,
        onAppearCallback: @escaping OnAppearCallback
    ) {
        self.product = product
        self.cartManager = cartManager
        self.onAppearCallback = onAppearCallback

        setupBindings()
    }

    // MARK: - Public

    func cellWillAppear() async {
        await onAppearCallback(product)
    }

    func addToCartButtonPressed() async {
        await cartManager.toggle(product)
    }
}
