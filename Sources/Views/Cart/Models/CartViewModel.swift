//
//  CartViewModel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine
import Foundation

@MainActor
final class CartViewModel: ObservableObject {
    // MARK: - Types

    enum State {
        case empty
        case cellsAvailable([CartCellViewModel], runningTotal: String)
    }

    // MARK: - Properties

    private let cartManager: CartManager

    @Published var state: State = .empty

    // MARK: - Internal

    private func setupBindings() {
        cartManager.allItems
            .map { [weak self] cart -> State in
                guard let self, !cart.isEmpty else {
                    return .empty
                }

                var runningTotal: Float = 0
                var cellViewModels = [CartCellViewModel]()

                for (product, amount) in cart {
                    runningTotal += (product.discountedPrice ?? product.price) * Float(amount)
                    cellViewModels.append(.init(
                        product: product,
                        cartManager: cartManager,
                        descriptionViewModel: .init(
                            product: product,
                            cartManager: cartManager
                        )
                    ))
                }

                let runningTotalString = NumberFormatter.currency.string(
                    from: NSNumber(value: runningTotal)
                ) ?? "\(runningTotal)"

                return .cellsAvailable(cellViewModels, runningTotal: runningTotalString)
            }
            .assign(to: &$state)
    }

    // MARK: - Initialization

    init(cartManager: CartManager) {
        self.cartManager = cartManager

        setupBindings()
    }
}
