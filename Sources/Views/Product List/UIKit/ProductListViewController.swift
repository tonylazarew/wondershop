//
//  ProductListViewController.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import Combine
import UIKit

private enum Const {
    static let reuseIdentifier = "Cell"
}

class ProductListViewController: UICollectionViewController {
    // MARK: - Properties

    private let coordinator: ShopFlowCoordinator
    private let viewModel: ProductListViewModel
    private let dataSource: ProductListDataSource
    private let refreshControl = UIRefreshControl()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Sub views

    private var activityIndicator: UIActivityIndicatorView?

    // MARK: - Initialization

    init(
        coordinator: ShopFlowCoordinator,
        viewModel: ProductListViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        dataSource = ProductListDataSource()

        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.dataSource = dataSource

        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductListViewController {
    // MARK: - Data bindings

    private func setupBindings() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { _ in self.handleStateUpdate() }
            .store(in: &cancellables)
    }

    private func handleStateUpdate() {
        switch viewModel.state {
        case .fetching:
            showLoadingIndicator()

        case let .cellsAvailable(itemViewModels):
            hideLoadingIndicator()
            dataSource.itemViewModels = itemViewModels
            collectionView.reloadData()

        case let .failure(message):
            print(message)
        }
    }

    private func startViewModel() {
        Task {
            await viewModel.start()
        }
    }
}

extension ProductListViewController {
    // MARK: - Activity indicator management

    private func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
    }

    private func showLoadingIndicator() {
        activityIndicator?.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
    }
}

extension ProductListViewController {
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.register(
            ProductListCollectionViewCell.self,
            forCellWithReuseIdentifier: Const.reuseIdentifier
        )

        // Do any additional setup after loading the view.

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)

        setupLoadingIndicator()
        startViewModel()
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: 200
        )
    }
}

extension ProductListViewController {
    @objc private func didPullToRefresh(_: Any) {
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }
}

extension ProductListViewController {
    // MARK: - UICollectionViewDelegate

    override func collectionView(
        _: UICollectionView,
        willDisplay _: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        // TODO: This is not very smooth yet

        let idx = indexPath.row
        let prefetchThreshold = dataSource.itemViewModels.count / 2

        guard idx > prefetchThreshold else {
            return
        }

        if let cellViewModel = dataSource.itemViewModels.last?.cellViewModel {
            Task {
                await cellViewModel.cellWillAppear()
            }
        }
    }

    /*
     override func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         let height = scrollView.frame.size.height

         if offsetY > contentHeight - height {
             print("load more data")
         }
     }
     */

    override func collectionView(
        _: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let idx = indexPath.row
        guard idx < dataSource.itemViewModels.count else {
            return
        }

        let viewModel = dataSource.itemViewModels[idx].descriptionViewModel
        coordinator.showProductDescription(with: viewModel)
    }
}

final class ProductListDataSource: NSObject, UICollectionViewDataSource {
    var itemViewModels: [ProductListViewModel.ItemViewModel] = []

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        itemViewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Const.reuseIdentifier,
            for: indexPath
        ) as! ProductListCollectionViewCell

        let viewModel = itemViewModels[indexPath.row].cellViewModel
        cell.configure(viewModel: viewModel)

        return cell
    }
}
