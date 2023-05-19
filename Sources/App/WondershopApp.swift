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

    var body: some Scene {
        WindowGroup {
            ProductList(viewModel: productListViewModel)
        }
    }
}
