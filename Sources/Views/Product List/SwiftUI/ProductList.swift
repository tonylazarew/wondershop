//
//  ProductList.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

struct ProductList: View {
    @ObservedObject private(set) var viewModel: ProductListViewModel
    @Environment(\.openWindow) var openWindow
    @Environment(\.supportsMultipleWindows) var supportsMultipleWindows

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .fetching:
                    ProgressView()

                case let .cellsAvailable(itemViewModels):
                    ScrollView {
                        LazyVStack(spacing: 4) {
                            ForEach(itemViewModels) { itemViewModel in
                                NavigationLink(value: itemViewModel.descriptionViewModel) {
                                    ProductListCell(viewModel: itemViewModel.cellViewModel)
                                }
                                .contextMenu {
                                    if supportsMultipleWindows {
                                        Button {
                                            openWindow(value: itemViewModel.id)
                                        } label: {
                                            Label("Open in a New Window", systemImage: "plus.rectangle")
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                            .navigationDestination(for: ProductDescriptionViewModel.self, destination: { viewModel in
                                ProductDescriptionView(viewModel: viewModel)
                            })
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }

                case let .failure(message):
                    VStack {
                        Text(message)
                            .font(.body)
                            .padding()
                        Button {
                            Task {
                                await viewModel.start()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .navigationTitle("Wondershop")
            .toolbar {
                NavigationLink {
                    CartView(viewModel: viewModel.cartViewModel)
                } label: {
                    ShowCartNavigationButton(viewModel: viewModel.showCartNavigationButtonViewModel)
                }
            }
            .task {
                await viewModel.start()
            }
        }
    }
}

#if DEBUG
struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Successful data fetch
            ProductList(viewModel: .init(
                productStore: PreviewProductStore(),
                cartManager: previewCartManager()
            ))

            // Failed data fetch
            ProductList(viewModel: .init(
                productStore: PreviewProductStore(behaviour: .failing),
                cartManager: previewCartManager()
            ))

            // Failed data fetch the first time, then succed
            ProductList(viewModel: .init(
                productStore: PreviewProductStore(behaviour: .failThenSucceed),
                cartManager: previewCartManager()
            ))

            // Successful data fetch from a local JSON file
            ProductList(viewModel: .init(
                productStore: PreviewProductStore(behaviour: .loadFromJSON),
                cartManager: previewCartManager()
            ))
        }
    }
}
#endif
