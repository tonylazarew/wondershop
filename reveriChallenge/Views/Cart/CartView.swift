//
//  CartView.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

struct CartView: View {

    @ObservedObject var viewModel: CartViewModel
    @State var showPopup: Bool = false

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.cellViewModels) { cellViewModel in
                    CartCell(viewModel: cellViewModel)
                }

                HStack {
                    Spacer()

                    Group {
                        Text("Total: ")
                        Text(viewModel.runningTotal)
                            .fontWeight(.bold)
                    }
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
