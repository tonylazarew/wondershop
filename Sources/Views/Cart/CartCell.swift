//
//  CartCell.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct CartCell: View {

    @ObservedObject var viewModel: CartCellViewModel

    @ScaledMetric(relativeTo: .body) var thumbnailSize = 70
    @ScaledMetric(relativeTo: .footnote) var amountWidth = 25

    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: viewModel.thumbnailURL)
                .placeholder(
                    Image(systemName: "photo.fill")
                )
                .resizable()
                .scaledToFill()
                .frame(width: thumbnailSize, height: thumbnailSize)
                .clipped()
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ProductDescriptionView(viewModel: viewModel.descriptionViewModel)
                        } label: {
                            Text(viewModel.title)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }

                        Text(viewModel.brand)
                            .font(.subheadline)
                    }
                }

                HStack {
                    Spacer()

                    Text(viewModel.price)
                        .font(.footnote)
                        .fontWeight(.bold)

                    Group {
                        Button {
                            Task {
                                await viewModel.decreaseButtonPressed()
                            }
                        } label: {
                            Image(systemName: "minus.square")
                        }
                        .buttonStyle(.plain)

                        Text("\(viewModel.amount)")
                            .font(.footnote)
                            .frame(width: amountWidth)

                        Button {
                            Task {
                                await viewModel.increaseButtonPressed()
                            }
                        } label: {
                            Image(systemName: "plus.square")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        let cartManager = previewCartManager()
        CartCell(viewModel: .init(
            product: .preview,
            cartManager: cartManager,
            descriptionViewModel: .init(
                product: .preview,
                cartManager: cartManager
            )
        ))
    }
}
#endif
