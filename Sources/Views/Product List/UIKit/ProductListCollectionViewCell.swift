//
//  ProductListCollectionViewCell.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import SDWebImage
import UIKit

struct ProductListCellConfiguration: UIContentConfiguration, Hashable {
    // MARK: - Properties

    var title: String = ""
    var brand: String = ""
    var thumbnailURL: URL?

    var dynamicCellHeight: CGFloat {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        return fontMetrics.scaledValue(for: 200)
    }

    // MARK: - UIContentConfiguration

    func makeContentView() -> UIView & UIContentView {
        ProductListCellContentView(configuration: self)
    }

    func updated(for _: UIConfigurationState) -> Self {
        // TODO: implement size updates
        self
    }
}

final class ProductListCellContentView: UIView, UIContentView {
    // MARK: - Subviews

    private lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        // imageView.layer.opacity = 0.8
        return imageView
    }()

    private lazy var title: CaptionLabel = {
        let label = CaptionLabel()
        label.textFont = .preferredFont(forTextStyle: .title2)
        label.textColor = .white
        label.stripeColor = .black
        label.cornerRadius = 5
        return label
    }()

    private lazy var brand: CaptionLabel = {
        let label = CaptionLabel()
        label.textFont = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .black
        label.stripeColor = .white.withAlphaComponent(0.8)
        label.cornerRadius = 2
        return label
    }()

    // MARK: - UIContentConfiguration

    var configuration: UIContentConfiguration {
        didSet {
            guard let configuration = configuration as? ProductListCellConfiguration else {
                return
            }

            configure(with: configuration)
        }
    }

    // MARK: - Internal

    private let contentPadding: CGFloat = 10
    private lazy var dynamicHeight: CGFloat = 200
    private lazy var dynamicHeightConstraint = heightAnchor.constraint(equalToConstant: dynamicHeight)

    // MARK: - Initialization

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration

        super.init(frame: .zero)

        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: bounds.width, height: dynamicHeight)
    }
}

private extension ProductListCellContentView {
    func configure(with configuration: ProductListCellConfiguration) {
        thumbnail.sd_setImage(
            with: configuration.thumbnailURL,
            placeholderImage: UIImage(systemName: "photo.fill")
        )
        title.text = configuration.title
        brand.text = configuration.brand

        dynamicHeight = configuration.dynamicCellHeight
        dynamicHeightConstraint.constant = configuration.dynamicCellHeight
        invalidateIntrinsicContentSize()
        print("configuration.dynamicCellHeight = \(configuration.dynamicCellHeight)")
    }
}

private extension ProductListCellContentView {
    func setupSubviews() {
        NSLayoutConstraint.activate([
            dynamicHeightConstraint,
        ])

        setupThumbnail()
        setupCaptions()
    }

    func setupThumbnail() {
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbnail)

        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnail.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnail.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    func setupCaptions() {
        title.translatesAutoresizingMaskIntoConstraints = false
        brand.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        addSubview(brand)

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentPadding),
            title.topAnchor.constraint(equalTo: topAnchor, constant: contentPadding),
            brand.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentPadding),
            brand.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
        ])
    }
}
