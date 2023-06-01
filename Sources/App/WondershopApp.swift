//
//  WondershopApp.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

@main
struct WondershopApp: App {
    private let productStore: ProductStore = DummyJSONProductStore()
    private let cartManager: CartManager
    private let productListViewModel: ProductListViewModel

    // MARK: - Properties

    @AppStorage("useSwiftUI") var cachedUseSwiftUI: Bool = true
    @State var useSwiftUI: Bool = true

    // MARK: - Initialization

    init() {
        let cartManager = CartManagerImpl(store: CartStoreImpl(repository: UserDefaults.standard))
        Task {
            await cartManager.loadFromStore()
        }
        self.cartManager = cartManager

        productListViewModel = ProductListViewModel(
            productStore: productStore,
            cartManager: cartManager
        )

        // Set up URLCache
        URLCache.shared.memoryCapacity = 50_000_000
        URLCache.shared.diskCapacity = 50_000_000
    }

    // MARK: - Private

    private func togglePresentation() {
        useSwiftUI.toggle()
        cachedUseSwiftUI = useSwiftUI
        print("useSwiftUI = \(useSwiftUI)")
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            Group {
#if canImport(UIKit)
                if useSwiftUI {
                    ProductList(viewModel: productListViewModel)
                } else {
                    RootViewControllerRepresentable(
                        rootViewModel: productListViewModel
                    )
                }
#else
                ProductList(viewModel: productListViewModel)
#endif
            }
            .animation(.linear(duration: 0.1), value: useSwiftUI)
            .onShake(togglePresentation)
            .onAppear { useSwiftUI = cachedUseSwiftUI }
        }
#if os(macOS)
        .defaultSize(width: 600, height: 600)
#endif

        WindowGroup("Product Details", for: Product.ID.self) { $productId in
            ProductDescriptionWindow(viewModel: .init(
                productStore: productStore,
                cartManager: cartManager,
                // TODO: This is a sneaky coalescing placeholder for a lack of better wiring
                id: productId ?? 0
            ))
        }
        .commandsRemoved()
#if os(macOS)
        .defaultSize(width: 400, height: 600)
#endif
    }
}
