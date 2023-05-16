//
//  CartViewModel.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine
import Foundation

@MainActor
final class CartViewModel: ObservableObject {

    private let cartManager: CartManager

    @Published var cellViewModels: [CartCellViewModel] = []
    @Published var runningTotal: String = ""

    // MARK: - Internal

    private func setupBindings() {
        cartManager.allItems
            .map { [weak self] cart in
                guard let self else {
                    return []
                }

                var cellViewModels = [CartCellViewModel]()

                for (product, _) in cart {
                    cellViewModels.append(.init(
                        product: product,
                        cartManager: cartManager,
                        descriptionViewModel: .init(
                            product: product,
                            cartManager: cartManager
                        )
                    ))
                }
                return cellViewModels
            }
            .assign(to: &$cellViewModels)

        cartManager.allItems
            .map { cart in
                var runningTotal: Float = 0
                for (product, amount) in cart {
                    runningTotal += (product.discountedPrice ?? product.price) * Float(amount)
                }

                let value = NumberFormatter.currency.string(from: NSNumber(value: runningTotal))
                guard let value else {
                    return "\(runningTotal)"
                }

                return value
            }
            .assign(to: &$runningTotal)
    }

    // MARK: - Initialization

    init(cartManager: CartManager) {
        self.cartManager = cartManager

        setupBindings()
    }

}
