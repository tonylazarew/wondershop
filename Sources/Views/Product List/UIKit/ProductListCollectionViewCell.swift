//
//  ProductListCollectionViewCell.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import SDWebImage
import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    var thumbnail: UIImageView!
    var title: CaptionLabel!
    var brand: CaptionLabel!

    // MARK: - Internal

    private let contentPadding: CGFloat = 10
    private var dynamicHeightConstraint: NSLayoutConstraint!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupThumbnail()
        setupText()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal

    private func calculateHeight() -> CGFloat {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        return fontMetrics.scaledValue(for: 200)
    }

    private func setupThumbnail() {
        thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.layer.opacity = 0.8
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnail)

        dynamicHeightConstraint = thumbnail.heightAnchor.constraint(equalToConstant: calculateHeight())

        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
//            thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dynamicHeightConstraint,
        ])
    }

    private func setupText() {
        title = CaptionLabel(padding: 5)
        title.textFont = .preferredFont(forTextStyle: .title2)
        title.textColor = .white
        title.stripeColor = .black
        title.cornerRadius = 5
        title.translatesAutoresizingMaskIntoConstraints = false

        brand = CaptionLabel(padding: 2)
        brand.textFont = .preferredFont(forTextStyle: .subheadline)
        brand.textColor = .black
        brand.stripeColor = .white.withAlphaComponent(0.8)
        brand.cornerRadius = 2
        brand.translatesAutoresizingMaskIntoConstraints = false

        addSubview(title)
        addSubview(brand)

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentPadding),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentPadding),
            brand.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentPadding),
            brand.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let cellHeight = calculateHeight()

        if cellHeight != dynamicHeightConstraint.constant {
            dynamicHeightConstraint.constant = cellHeight

            layoutIfNeeded()
        }
    }

    // MARK: - Public

    func configure(viewModel: ProductListCellViewModel) {
        thumbnail.sd_setImage(
            with: viewModel.thumbnailURL,
            placeholderImage: UIImage(systemName: "photo.fill")
        )
        title.text = viewModel.title
        brand.text = viewModel.brand
    }
}
