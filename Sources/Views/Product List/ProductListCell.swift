//
//  ProductListCell.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProductListCell: View {
    @ObservedObject var viewModel: ProductListCellViewModel

    @State var isInCart = false
    @ScaledMetric(relativeTo: .body) private var thumbnailHeight = 200

    @MainActor
    var thumbnailImage: some View {
        WebImage(url: viewModel.thumbnailURL)
            .placeholder(
                Image(systemName: "photo.fill")
            )
            .resizable()
            .scaledToFill()
    }

    @MainActor
    @ViewBuilder
    var priceView: some View {
        if viewModel.discountedPrice != nil {
            Text(viewModel.price)
                .font(.body)
                .foregroundColor(.yellow)
                .padding(5)
                .background(Color.black)
                .overlay {
                    Rectangle()
                        .fill(.red)
                        .frame(height: 3)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .opacity(0.8)
        }

        Text(viewModel.discountedPrice ?? viewModel.price)
            .font(.body)
            .foregroundColor(.white)
            .padding(5)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    var body: some View {
        ZStack {

            // Thumbnail behind the description

            thumbnailImage
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: thumbnailHeight)
                .opacity(0.8)

            Group {
                VStack(alignment: .leading, spacing: 0) {

                    // Title and brand

                    Text(viewModel.title)
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                    Text(viewModel.brand)
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 4)
                        .padding(2)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 2))

                    Spacer()

                    // Pricing info and add to cart button

                    HStack(alignment: .center, spacing: 0) {
                        Spacer()

                        priceView
                            .lineLimit(1)

                        Button {
                            Task {
                                await viewModel.addToCartButtonPressed()
                            }
                        } label: {
                            Image(systemName: viewModel.isInCart ? "cart.fill.badge.minus" : "cart.badge.plus")
                                .renderingMode(.original)
                                .foregroundColor(viewModel.isInCart ? .white : .black)
                                .padding(5)
                                .background(viewModel.isInCart ? Color.black : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }
            }
            .padding(10)
        }
        .clipped()
        .task {
            await viewModel.cellWillAppear()
        }
    }}

#if DEBUG
struct ProductListCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductListCell(viewModel: .init(
            product: .preview,
            cartManager: previewCartManager()
        ) { _ in })
    }
}
#endif
