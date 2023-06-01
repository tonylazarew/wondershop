//
//  CaptionLabel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 28/05/2023.
//

#if canImport(UIKit)

import UIKit

class CaptionLabel: UIView {
    private let backgroundView = UIView()
    private let label = UILabel()
    private let padding: CGFloat

    // MARK: - Initialization

    init(padding: CGFloat = 5) {
        self.padding = padding

        super.init(frame: .zero)

        // Setup the background view
        backgroundView.backgroundColor = UIColor.black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        // Setup the label
        label.textAlignment = .natural
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),

            heightAnchor.constraint(equalTo: label.heightAnchor, constant: 2 * padding),
            widthAnchor.constraint(equalTo: label.widthAnchor, constant: 2 * padding),

            backgroundView.topAnchor.constraint(equalTo: label.topAnchor, constant: -padding),
            backgroundView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -padding),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CaptionLabel {
    // MARK: - Properties

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }

    var textFont: UIFont {
        get { label.font }
        set { label.font = newValue }
    }

    var stripeColor: UIColor? {
        get { backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }

    var cornerRadius: CGFloat {
        get { backgroundView.layer.cornerRadius }
        set { backgroundView.layer.cornerRadius = newValue }
    }
}

#endif
