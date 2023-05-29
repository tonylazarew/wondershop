//
//  RatingView.swift
//  Wondershop
//
//  Created by Anton Lazarev on 29/05/2023.
//

import UIKit

class RatingView: UIView {
    // MARK: - Consts

    private enum Const {
        static let range = 1 ... 5

        static let uiImageConfiguration = UIImage.SymbolConfiguration(textStyle: .footnote)

        static let emptyStar = UIImage(
            systemName: "star",
            withConfiguration: uiImageConfiguration
        )!.withRenderingMode(.alwaysTemplate)

        static let filledStar = UIImage(
            systemName: "star.fill",
            withConfiguration: uiImageConfiguration
        )!.withRenderingMode(.alwaysOriginal)
    }

    // MARK: - Subviews

    private var imageViews: [UIImageView] = Array(Const.range)
        .map { _ in
            let view = UIImageView(image: Const.emptyStar)
            view.tintColor = .secondaryLabel
            return view
        }

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var stackView: UIStackView = {
        let starStack = UIStackView(arrangedSubviews: imageViews)
        starStack.axis = .horizontal
        starStack.spacing = 0

        let stack = UIStackView(arrangedSubviews: [starStack, ratingLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RatingView {
    // MARK: - Public

    func setRating(_ rating: Int, text: String) {
        Const.range.forEach { i in
            imageViews[i - 1].image = i <= rating ? Const.filledStar : Const.emptyStar
        }
        ratingLabel.text = text
    }
}
