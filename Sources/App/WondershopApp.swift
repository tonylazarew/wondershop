//
//  WondershopApp.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

@main
struct WondershopApp: App {
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
            productStore: DummyJSONProductStore(),
            cartManager: cartManager
        )
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
                if useSwiftUI {
                    ProductList(viewModel: productListViewModel)
                } else {
                    RootViewControllerRepresentable(
                        rootViewModel: productListViewModel
                    )
                }
            }
            .animation(.linear(duration: 0.1), value: useSwiftUI)
            .onShake(togglePresentation)
            .onAppear { useSwiftUI = cachedUseSwiftUI }
        }
    }
}
