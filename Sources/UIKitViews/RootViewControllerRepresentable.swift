//
//  RootViewControllerRepresentable.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import SwiftUI

struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> RootViewController {
        RootViewController()
    }

    func updateUIViewController(_: RootViewController, context _: Context) {}
}
