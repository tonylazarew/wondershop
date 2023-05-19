//
//  CartStorePreview.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

#if DEBUG

final class PreviewCartStore: CartStore {

    var currentCart: Cart = [:]

    func updateCurrentCart(_ cart: Cart) async {}

}

#endif
