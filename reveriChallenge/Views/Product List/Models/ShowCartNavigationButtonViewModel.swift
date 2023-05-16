//
//  ShowCartNavigationButtonViewModel.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Combine

@MainActor
final class ShowCartNavigationButtonViewModel: ObservableObject {

    // MARK: - Properties

    private let cartStateReadable: CartStateReadable

    @Published var cartCount: String = ""

    // MARK: - Initialization

    init(cartStateReadable: CartStateReadable) {
        self.cartStateReadable = cartStateReadable

        setupBindings()
    }

    private func setupBindings() {
        cartStateReadable.count
            .map { "\($0)" }
            .assign(to: &$cartCount)
    }

}
