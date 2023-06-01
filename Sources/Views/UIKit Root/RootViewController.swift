//
//  RootViewController.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

#if canImport(UIKit)

import Combine
import UIKit

final class RootViewController: UIViewController {
    // MARK: - Properties

    private let shopFlowCoordinator: ShopFlowCoordinator
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(rootViewModel: ProductListViewModel) {
        let navController = UINavigationController()
        navController.modalPresentationStyle = .fullScreen
        shopFlowCoordinator = ShopFlowCoordinator(
            navigationController: navController,
            rootViewModel: rootViewModel
        )

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootViewController {
    // MARK: - Public

    func dismantle() {
        shopFlowCoordinator.stop()
    }
}

extension RootViewController {
    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        present(shopFlowCoordinator.navigationController, animated: false)
        shopFlowCoordinator.start()
    }
}

#endif
