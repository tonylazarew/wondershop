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
    private let refreshControl = UIRefreshControl()

    private var cancellables = Set<AnyCancellable>()
    private var cellWillAppearTask: Task<Void, Never>?

    private lazy var dataSource = makeDataSource()

    typealias ItemViewModel = ProductListViewModel.ItemViewModel
    private var itemViewModels: [ItemViewModel] = []

    // MARK: - Subviews

    private var activityIndicator: UIActivityIndicatorView?

    // MARK: - Initialization

    init(
        coordinator: ShopFlowCoordinator,
        viewModel: ProductListViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(collectionViewLayout: layout)

        collectionView.dataSource = dataSource
        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductListViewController {
    // MARK: - UIViewController

    override func loadView() {
        super.loadView()

        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)

        navigationItem.title = "Wondershop"

        setupLoadingIndicator()
        startViewModel()
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
            productListDidUpdate(with: itemViewModels)
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
    @objc private func didPullToRefresh(_: Any) {
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }
}

extension ProductListViewController {
    // MARK: - UICollectionViewDelegate

    /*
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

         if let cellViewModel = dataSource.itemViewModels.last?.cellViewModel,
            cellWillAppearTask == nil {
             print("\(Date()) cellWillAppear() for \(cellViewModel.title)")
             cellWillAppearTask = Task {
                 await cellViewModel.cellWillAppear()
                 cellWillAppearTask = nil
             }

         }
     }
      */

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY < contentHeight - height || cellWillAppearTask != nil {
            return
        }

        if let cellViewModel = itemViewModels.last?.cellViewModel {
            cellWillAppearTask = Task {
                print("ENTR: cellWillAppear() for \(cellViewModel.title)")

                await cellViewModel.cellWillAppear()

                print("DONE: cellWillAppear() for \(cellViewModel.title)")
                cellWillAppearTask = nil
            }
        }
    }

    override func collectionView(
        _: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let idx = indexPath.row
        guard idx < itemViewModels.count else {
            return
        }

        let viewModel = itemViewModels[idx].descriptionViewModel
        coordinator.showProductDescription(with: viewModel)
    }
}

private extension ProductListViewController {
    // MARK: - Diffable data source

    private enum Section: Int {
        case main
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, ProductListCellViewModel> {
        .init(
            collectionView: collectionView,
            cellProvider: makeCellRegistration().cellProvider
        )
    }

    private func productListDidUpdate(with itemViewModels: [ItemViewModel]) {
        self.itemViewModels = itemViewModels

        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductListCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemViewModels.map(\.cellViewModel))
        dataSource.apply(snapshot)
    }
}

private extension ProductListViewController {
    // MARK: - Cell registration

    typealias Cell = UICollectionViewCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, ProductListCellViewModel>

    func makeCellRegistration() -> CellRegistration {
        .init { cell, _, viewModel in
            let configuration = ProductListCellConfiguration(
                title: viewModel.title,
                brand: viewModel.brand,
                thumbnailURL: viewModel.thumbnailURL
            )

            cell.contentConfiguration = configuration
        }
    }
}

private extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: self,
                for: indexPath,
                item: item
            )
        }
    }
}
