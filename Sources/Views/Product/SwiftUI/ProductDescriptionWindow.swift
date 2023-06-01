//
//  ProductDescriptionWindow.swift
//  Wondershop
//
//  Created by Anton Lazarev on 01/06/2023.
//

import SwiftUI

struct ProductDescriptionWindow: View {
    @ObservedObject var viewModel: ProductDescriptionWindowModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case let .failure(message):
                Text(message)
            case let .data(viewModel):
                ProductDescriptionView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

struct ProductDescriptionWindow_Previews: PreviewProvider {
    static var previews: some View {
        ProductDescriptionWindow(viewModel: .preview)
    }
}
