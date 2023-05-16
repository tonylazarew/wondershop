//
//  CartStore.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

protocol CartStore {
    var currentCart: Cart { get async }
    func updateCurrentCart(_ cart: Cart) async
}
