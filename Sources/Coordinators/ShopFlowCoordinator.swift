//
//  ShopFlowCoordinator.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import UIKit

final class ShopFlowCoordinator: Coordinator {
    // MARK: - Properties

    let navigationController: UINavigationController

    private let rootViewModel: ProductListViewModel
    private var isPresented: Bool = false

    // MARK: - Initialization

    init(
        navigationController: UINavigationController,
        rootViewModel: ProductListViewModel
    ) {
        self.navigationController = navigationController
        self.rootViewModel = rootViewModel
    }

    // MARK: - Public

    func start() {
        let productListVC = ProductListViewController(
            coordinator: self,
            viewModel: rootViewModel
        )
        navigationController.pushViewController(productListVC, animated: false)
        isPresented = true
    }

    func stop() {
        navigationController.dismiss(animated: false)
    }
}

extension ShopFlowCoordinator {
    // MARK: - Navigation

    func showProductDescription(with viewModel: ProductDescriptionViewModel) {
        Task {
            let title = await viewModel.title
            print("showProductDescription: title = \(title)")
        }

        let vc = ProductDescriptionViewController(
            coordinator: self,
            viewModel: viewModel
        )
        navigationController.pushViewController(vc, animated: true)
    }
}
