//
//  CartView.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: CartViewModel
    @State var showPopup: Bool = false

    var emptyCart: some View {
        VStack(alignment: .center) {
            Group {
                Image(systemName: "cart.badge.questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)

                Text("Your cart is empty")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.accentColor)

            Text("Have you checked out the wondershop yet?")
                .font(.footnote)
        }
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .empty:
                emptyCart

            case let .cellsAvailable(cellViewModels, runningTotal):
                List {
                    ForEach(cellViewModels) { cellViewModel in
                        CartCell(viewModel: cellViewModel)
                    }

                    HStack {
                        Spacer()

                        Group {
                            Text("Total: ")
                            Text(runningTotal)
                                .fontWeight(.bold)
                        }
                        .animation(.easeIn(duration: 0.1), value: runningTotal)
                        .font(.footnote)
                    }

                    Button {
                        showPopup.toggle()
                    } label: {
                        Spacer()
                        Text("Checkout")
                        Spacer()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
                .listStyle(.inset)
            }
        }
        .navigationTitle("Cart")
        .sheet(isPresented: $showPopup) {
            VStack {
                Image(systemName: "face.dashed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                Text("Not quite implemented yet...")
                    .padding()
            }
            .foregroundColor(.accentColor)
            .onTapGesture {
                showPopup.toggle()
            }
        }
    }
}

#if DEBUG
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: .init(cartManager: previewCartManager()))
    }
}
#endif
