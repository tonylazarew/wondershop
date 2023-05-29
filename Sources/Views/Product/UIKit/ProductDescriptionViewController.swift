//
//  ProductDescriptionViewController.swift
//  Wondershop
//
//  Created by Anton Lazarev on 29/05/2023.
//

import UIKit

class ProductDescriptionViewController: UIViewController {
    // MARK: - Properties

    private let coordinator: ShopFlowCoordinator
    private let viewModel: ProductDescriptionViewModel

    private lazy var photoContainerHeightConstraint = photoContainer.heightAnchor.constraint(
        equalToConstant: photoContainerHeight
    )

    private var photoPageControlHideTask: Task<Void, Never>?

    // MARK: - Subviews

    private lazy var rootScrollView: UIScrollView = .init()

    private lazy var photoContainer: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private var photoPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .secondaryLabel.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .accentColor
        return pageControl
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .accentColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var ratingView: RatingView = .init()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Initialization

    init(
        coordinator: ShopFlowCoordinator,
        viewModel: ProductDescriptionViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductDescriptionViewController {
    // MARK: - UIViewController

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground

        rootScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootScrollView)

        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        setupPhotoContainer()
        setupDescriptionSection()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        photoPageControl.numberOfPages = viewModel.imageURLs.count
        if photoPageControl.numberOfPages <= 1 {
            photoPageControl.alpha = 0
        }

        titleLabel.text = viewModel.title
        brandLabel.text = viewModel.brand

        categoryLabel.text = viewModel.category
        stockLabel.text = viewModel.stock
        ratingView.setRating(viewModel.ratingStars, text: viewModel.rating)

        descriptionLabel.text = viewModel.description

        // Schedule page control hiding
        hidePhotoPageControl()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Update photo container height if needed
        if photoContainerHeightConstraint.constant != photoContainerHeight {
            updatePhotoContainerHeight()
        }
    }
}

private extension ProductDescriptionViewController {
    // MARK: - Photo container setup

    var photoContainerHeight: CGFloat {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        return fontMetrics.scaledValue(for: 200)
    }

    func updatePhotoContainerHeight() {
        photoContainerHeightConstraint.constant = photoContainerHeight
    }

    func setupPhotoContainer() {
        photoContainer.translatesAutoresizingMaskIntoConstraints = false
        photoPageControl.translatesAutoresizingMaskIntoConstraints = false
        updatePhotoContainerHeight()

        rootScrollView.addSubview(photoContainer)
        rootScrollView.addSubview(photoPageControl)

        photoContainer.delegate = self

        NSLayoutConstraint.activate([
            photoContainer.topAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.topAnchor),
            photoContainer.leadingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.leadingAnchor),
            photoContainer.widthAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.widthAnchor),
            photoContainerHeightConstraint,

            photoPageControl.topAnchor.constraint(equalTo: photoContainer.bottomAnchor),
            photoPageControl.centerXAnchor.constraint(equalTo: photoContainer.centerXAnchor),
        ])

        setupPhotos()
    }

    func setupPhotos() {
        var imageViews = [UIImageView]()

        imageViews = viewModel.imageURLs
            .map { url in
                let imageView = UIImageView()

                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(systemName: "photo.fill")
                )
                imageView.contentMode = .scaleAspectFit

                return imageView
            }

        imageViews
            .enumerated()
            .forEach { i, view in
                photoContainer.addSubview(view)

                let leadingAnchor = (i == 0)
                    ? photoContainer.contentLayoutGuide.leadingAnchor
                    : imageViews[i - 1].trailingAnchor

                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: photoContainer.contentLayoutGuide.topAnchor),
                    view.bottomAnchor.constraint(equalTo: photoContainer.contentLayoutGuide.bottomAnchor),
                    view.heightAnchor.constraint(equalTo: photoContainer.frameLayoutGuide.heightAnchor),
                    view.widthAnchor.constraint(equalTo: photoContainer.frameLayoutGuide.widthAnchor),
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                ])

                if i == imageViews.count - 1 {
                    view.trailingAnchor.constraint(
                        equalTo: photoContainer.contentLayoutGuide.trailingAnchor
                    ).isActive = true
                }
            }
    }

    func showPhotoPageControl() {
        guard photoPageControl.numberOfPages > 1 else {
            photoPageControl.alpha = 0
            return
        }

        photoPageControlHideTask?.cancel()
        UIView.animate(withDuration: 0.3) {
            self.photoPageControl.alpha = 1
        }
    }

    func hidePhotoPageControl() {
        photoPageControlHideTask?.cancel()
        photoPageControlHideTask = Task {
            do {
                try await Task.sleep(for: .seconds(1))
                UIView.animate(withDuration: 0.8) {
                    self.photoPageControl.alpha = 0
                }
            } catch {}
        }
    }
}

private extension ProductDescriptionViewController {
    // MARK: - Description setup

    var descriptionPadding: CGFloat { 10 }

    func setupDescriptionSection() {
        setupTitleLabel()
        setupBrandLabel()

        setupCategoryLabel()
        setupStockLabel()

        setupRatingView()
        setupDescriptionText()
    }

    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: photoContainer.bottomAnchor,
                constant: descriptionPadding * 2
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.leadingAnchor,
                constant: descriptionPadding
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: rootScrollView.frameLayoutGuide.trailingAnchor,
                constant: -descriptionPadding
            ),
        ])
    }

    func setupBrandLabel() {
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.addSubview(brandLabel)

        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: descriptionPadding / 2
            ),
            brandLabel.leadingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.leadingAnchor,
                constant: descriptionPadding
            ),
            brandLabel.trailingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.trailingAnchor,
                constant: -descriptionPadding
            ),
        ])
    }

    func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(
                equalTo: brandLabel.bottomAnchor,
                constant: descriptionPadding
            ),
            categoryLabel.leadingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.leadingAnchor,
                constant: descriptionPadding
            ),
            categoryLabel.trailingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.trailingAnchor,
                constant: -descriptionPadding
            ),
        ])
    }

    func setupStockLabel() {
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.addSubview(stockLabel)

        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(
                equalTo: categoryLabel.bottomAnchor
            ),
            stockLabel.leadingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.leadingAnchor,
                constant: descriptionPadding
            ),
            stockLabel.trailingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.trailingAnchor,
                constant: -descriptionPadding
            ),
        ])
    }

    func setupRatingView() {
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.addSubview(ratingView)

        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(
                equalTo: stockLabel.bottomAnchor,
                constant: descriptionPadding
            ),
            ratingView.leadingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.leadingAnchor,
                constant: descriptionPadding
            ),
        ])
    }

    func setupDescriptionText() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: ratingView.bottomAnchor,
                constant: descriptionPadding * 2
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.leadingAnchor,
                constant: descriptionPadding
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.trailingAnchor,
                constant: -descriptionPadding
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: rootScrollView.contentLayoutGuide.bottomAnchor,
                constant: -descriptionPadding
            ),
            descriptionLabel.widthAnchor.constraint(
                equalTo: rootScrollView.frameLayoutGuide.widthAnchor,
                constant: -descriptionPadding * 2
            ),
        ])
    }
}

extension ProductDescriptionViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == photoContainer else {
            return
        }

        showPhotoPageControl()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == photoContainer else {
            return
        }

        let page = Int((scrollView.contentOffset.x / scrollView.bounds.width).rounded())
        photoPageControl.currentPage = page

        hidePhotoPageControl()
    }
}
