//
//  Product.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

struct Product: Identifiable, Equatable, Hashable {
    let id: Int

    let title: String
    let brand: String
    let description: String

    let price: Float
    let discountPercentage: Float?
    let rating: Float
    let stock: Int

    let category: String

    let thumbnailURL: URL?
    let imagesURLs: [URL?]

    var discountedPrice: Float? {
        guard let discountPercentage else {
            return nil
        }
        return price * (1 - discountPercentage * 0.01)
    }
}

#if DEBUG
extension Product {
    static var previews: [Product] {
        [
            .init(
                id: 1, title: "title 1", brand: "brand 1",
                description: "desc 1", price: 5, discountPercentage: nil,
                rating: 3, stock: 5,
                category: "cat",
                thumbnailURL: URL(string: "http://localhost/1.jpg"),
                imagesURLs: [URL(string: "http://localhost/1.jpg")]
            ),
            .init(
                id: 2, title: "title 2", brand: "brand 2",
                description: "desc 2", price: 5, discountPercentage: 3,
                rating: 1, stock: 5,
                category: "cat",
                thumbnailURL: URL(string: "http://localhost/2.jpg"),
                imagesURLs: [URL(string: "http://localhost/2.jpg")]
            ),
        ]
    }

    static var preview: Product = Product.previews[0]
}
#endif
