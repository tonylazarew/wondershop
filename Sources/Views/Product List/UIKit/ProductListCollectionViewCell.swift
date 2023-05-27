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
    var title: UILabel!
    var brand: UILabel!

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

    private func setupThumbnail() {
        thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnail)

        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnail.heightAnchor.constraint(equalToConstant: 200),
//            thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private func setupText() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        title = UILabel()
        brand = UILabel()
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(brand)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
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
