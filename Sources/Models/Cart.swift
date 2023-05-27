//
//  Cart.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation
import OrderedCollections

typealias ProductAmount = Int
typealias Cart = OrderedDictionary<Product, ProductAmount>
