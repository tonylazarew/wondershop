//
//  CartRepository.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

protocol CartRepository {
    func getData() -> Data?
    func setData(_ value: Data)
    func remove()
}
