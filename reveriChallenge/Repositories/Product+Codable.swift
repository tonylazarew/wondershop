//
//  Product+Encodable.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

extension Product {
    private enum ProductCodingKeys: String, CodingKey {
        case id, title, brand, description
        case price, discountPercentage
        case rating, stock
        case category
        case thumbnail, images
    }
}

extension Product: Encodable {
    enum EncodeError: Error {
        case imageURLIsMissing
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ProductCodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(brand, forKey: .brand)
        try container.encode(description, forKey: .description)
        try container.encode(price, forKey: .price)
        try container.encode(discountPercentage, forKey: .discountPercentage)
        try container.encode(rating, forKey: .rating)
        try container.encode(stock, forKey: .stock)
        try container.encode(category, forKey: .category)

        guard let thumbnailURL else {
            throw EncodeError.imageURLIsMissing
        }

        try container.encode(thumbnailURL.absoluteString, forKey: .thumbnail)

        let images: [String] = try imagesURLs.map { url in
            guard let url else {
                throw EncodeError.imageURLIsMissing
            }

            return url.absoluteString
        }

        try container.encode(images, forKey: .images)
    }

}

extension Product: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        brand = try container.decode(String.self, forKey: .brand)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Float.self, forKey: .price)
        discountPercentage = try container.decode(Float.self, forKey: .discountPercentage)
        rating = try container.decode(Float.self, forKey: .rating)
        stock = try container.decode(Int.self, forKey: .stock)
        category = try container.decode(String.self, forKey: .category)

        do {
            let thumbnailString = try container.decode(String.self, forKey: .thumbnail)
            thumbnailURL = URL(string: thumbnailString)
        } catch {
            print("\(error)")
            throw error
        }

        let images = try container.decode([String].self, forKey: .images)
        imagesURLs = images.map { URL(string: $0) }
    }
}
