//
//  ProductDescriptionView.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

struct ProductDescriptionView: View {
    @ObservedObject var viewModel: ProductDescriptionViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
#if os(iOS)
                GeometryReader { geometry in
                    TabView {
                        ForEach(viewModel.imageURLs) { imageURL in
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }
                            .frame(height: geometry.size.height)
                            .clipped()
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(.page(indexDisplayMode: .always))
#elseif os(macOS)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(viewModel.imageURLs) { imageURL in
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }
                            .frame(height: 300)
                            .clipped()
                        }
                    }
                }
#endif

                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)

                        Text(viewModel.brand)
                            .font(.subheadline)

                        VStack(alignment: .leading) {
                            Text(viewModel.category)
                            Text(viewModel.stock)
                        }
                        .padding(.top, 1)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }

                    Spacer()

                    HStack(alignment: .center) {
                        Text(viewModel.price)
                            .lineLimit(1)
                            .fontWeight(.bold)

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
                        .buttonStyle(.borderless)
                    }
                }
                .padding()

                HStack(alignment: .center) {
                    ForEach(Range(1 ... 5), id: \.self) { starNo in
                        if starNo <= viewModel.ratingStars {
                            Image(systemName: "star.fill")
                                .renderingMode(.original)
                        } else {
                            Image(systemName: "star")
                        }
                    }
                    Text("\(viewModel.rating)")
                }
                .padding(.leading)

                Text(viewModel.description)
                    .font(.body)
                    .padding()

                Spacer()
            }
        }
    }
}

#if DEBUG
struct ProductDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDescriptionView(viewModel: .init(
            product: .preview,
            cartManager: previewCartManager()
        ))
    }
}
#endif
