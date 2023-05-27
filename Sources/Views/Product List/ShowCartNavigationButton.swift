//
//  ShowCartNavigationButton.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import SwiftUI

struct ShowCartNavigationButton: View {
    @ObservedObject var viewModel: ShowCartNavigationButtonViewModel

    var body: some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .padding(.trailing, 5)

                Text(viewModel.cartAmount)
                    .font(Font(CTFont(.smallSystem, size: 12)))
                    .padding(2)
                    .padding(.horizontal, 2)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                    .animation(.default, value: viewModel.cartAmount)
            }
            Text("Cart")
        }
    }
}

#if DEBUG
struct ShowCartNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowCartNavigationButton(viewModel: .init(cartStateReadable: previewCartManager()))
    }
}
#endif
