//
//  ProductUpdatesTests.swift
//  WondershopTests
//
//  Created by Anton Lazarev on 17/05/2023.
//

@testable import Wondershop

import Combine
import XCTest

final class ProductUpdatesTests: XCTestCase {

    var sut: CartManager!
    var cancellables = Set<AnyCancellable>()

    override func setUp() async throws {
        sut = CartManagerImpl(store: PreviewCartStore())
    }

    func test_addingProductWillUpdateProductAmount() async throws {
        // Given
        let product = Product.preview

        // When
        await sut.add(product)

        // Then
        let expectation = expectation(description: "Should receive an updated amount")

        var updatedAmount = 0

        sut.streamUpdates(for: product)
            .sink { amount in
                updatedAmount = amount
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation])
        XCTAssertEqual(updatedAmount, 1)
    }

    func test_droppingProductWillUpdateProductAmount() async throws {
        // Given
        let product = Product.preview

        // Here we subscribe before the updates, should get 3 notifications
        let expectation = expectation(description: "Should receive an updated amount")
        expectation.expectedFulfillmentCount = 3

        var updatedAmount = 1

        sut.streamUpdates(for: product)
            .sink { amount in
                updatedAmount = amount
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        await sut.add(product)
        await sut.drop(product)

        // Then
        await fulfillment(of: [expectation])
        XCTAssertEqual(updatedAmount, 0)
    }

}
