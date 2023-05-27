//
//  ProductListViewModel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine
import Foundation

@MainActor
final class ProductListViewModel: ObservableObject {
    // MARK: - Types

    struct ItemViewModel: Identifiable {
        let id: Int

        let cellViewModel: ProductListCellViewModel
        let descriptionViewModel: ProductDescriptionViewModel
    }

    enum State {
        case fetching
        case cellsAvailable([ItemViewModel])
        case failure(message: String)
    }

    // MARK: - Internal

    private let productStore: ProductStore
    private let cartManager: CartManager

    private var lastProductId: Product.ID?

    // MARK: - Properties

    @Published var state: State = .fetching

    let showCartNavigationButtonViewModel: ShowCartNavigationButtonViewModel
    let cartViewModel: CartViewModel

    // MARK: - Initialization

    init(
        productStore: ProductStore,
        cartManager: CartManager
    ) {
        self.productStore = productStore
        self.cartManager = cartManager

        showCartNavigationButtonViewModel = ShowCartNavigationButtonViewModel(cartStateReadable: cartManager)
        cartViewModel = CartViewModel(cartManager: cartManager)
    }

    // MARK: - Public

    func start() async {
        switch state {
        case .fetching, .failure:
            // Only update if we are either in an initial fetching or in a failure state
            await refresh()
        case .cellsAvailable:
            break
        }
    }

    func refresh() async {
        do {
            let viewModels = try await productStore.fetch()
                .map {
                    ItemViewModel(
                        id: $0.id,
                        cellViewModel: ProductListCellViewModel(
                            product: $0,
                            cartManager: cartManager
                        ) { [weak self] product in
                            await self?.maybeFetchMore(after: product)
                        },
                        descriptionViewModel: ProductDescriptionViewModel(
                            product: $0,
                            cartManager: cartManager
                        )
                    )
                }

            lastProductId = viewModels.last?.id
            state = .cellsAvailable(viewModels)
        } catch {
            state = .failure(message: "Could not fetch products, try again later")
            print("ProductListViewModel error: \(error)")
        }
    }

    func maybeFetchMore(after product: Product) async {
        do {
            guard
                let lastProductId,
                product.id == lastProductId,
                case let .cellsAvailable(currentViewModels) = state
            else {
                return
            }

            let newViewModels = try await productStore.fetch(after: product)
                .map {
                    ItemViewModel(
                        id: $0.id,
                        cellViewModel: ProductListCellViewModel(
                            product: $0,
                            cartManager: cartManager
                        ) { [weak self] product in
                            await self?.maybeFetchMore(after: product)
                        },
                        descriptionViewModel: ProductDescriptionViewModel(
                            product: $0,
                            cartManager: cartManager
                        )
                    )
                }

            var viewModels = currentViewModels
            viewModels.append(contentsOf: newViewModels)
            self.lastProductId = newViewModels.last?.id
            state = .cellsAvailable(viewModels)
        } catch {
            print("ProductListViewModel error: \(error)")
        }
    }
}
