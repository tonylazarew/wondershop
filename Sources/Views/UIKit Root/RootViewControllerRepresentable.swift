//
//  RootViewControllerRepresentable.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import SwiftUI

#if canImport(UIKit)

struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    private let rootViewModel: ProductListViewModel

    init(
        rootViewModel: ProductListViewModel
    ) {
        self.rootViewModel = rootViewModel
    }
}

extension RootViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> RootViewController {
        RootViewController(rootViewModel: rootViewModel)
    }

    func updateUIViewController(_: RootViewController, context _: Context) {}

    static func dismantleUIViewController(_ rootViewController: RootViewController, coordinator _: ()) {
        rootViewController.dismantle()
    }
}

#endif
