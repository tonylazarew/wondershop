//
//  CaptionLabel.swift
//  Wondershop
//
//  Created by Anton Lazarev on 28/05/2023.
//

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
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Setup the label
        label.textAlignment = .natural
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
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
