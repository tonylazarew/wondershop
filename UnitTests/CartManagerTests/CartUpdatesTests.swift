//
//  CartStateReadableTest.swift
//  WondershopTests
//
//  Created by Anton Lazarev on 17/05/2023.
//

@testable import Wondershop

import Combine
import XCTest

final class CartUpdatesTests: XCTestCase {
    var sut: CartManager!
    var cancellables = Set<AnyCancellable>()

    override func setUp() async throws {
        sut = CartManagerImpl(store: PreviewCartStore())
    }

    func test_addingProductWillUpdateCart() async throws {
        // Given
        let product = Product.preview

        // When
        await sut.add(product)

        // Then
        let allItemsExpectation = expectation(description: "Should receive an updated cart")
        let countExpectation = expectation(description: "Should receive an updated product amount")

        var updatedCart = Cart()
        var updatedCount = 0

        sut.allItems
            .sink { cart in
                updatedCart = cart
                allItemsExpectation.fulfill()
            }
            .store(in: &cancellables)

        sut.amount
            .sink { count in
                updatedCount = count
                countExpectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [allItemsExpectation, countExpectation])
        XCTAssertTrue(updatedCart.keys.contains(product), "Product was not added into cart")
        XCTAssertEqual(updatedCart[product]!, 1, "Wrong product amount")
        XCTAssertEqual(updatedCart.count, 1, "Wrong cart size")
        XCTAssertEqual(updatedCount, 1)
    }

    func test_addingProductTwiceWillUpdateAmount() async throws {
        // Given
        let product = Product.preview

        // When
        await sut.add(product)
        await sut.add(product)

        // Then
        let allItemsExpectation = expectation(description: "Should receive an updated cart")
        let countExpectation = expectation(description: "Should receive an updated product amount")

        var updatedCart = Cart()
        var updatedCount = 0

        // We subscribe after the updates so we should only get one notification
        sut.allItems
            .sink { cart in
                updatedCart = cart
                allItemsExpectation.fulfill()
            }
            .store(in: &cancellables)

        sut.amount
            .sink { count in
                updatedCount = count
                countExpectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [allItemsExpectation, countExpectation])
        XCTAssertTrue(updatedCart.keys.contains(product), "Product was not added into cart")
        XCTAssertEqual(updatedCart[product]!, 2, "Wrong product amount")
        XCTAssertEqual(updatedCart.count, 1, "Wrong cart size")
        XCTAssertEqual(updatedCount, 2)
    }

    func test_droppingProductWillUpdateCart() async throws {
        // Given
        let product = Product.preview

        // Here we subscribe before the updates, should get 3 notifications
        let allItemsExpectation = expectation(description: "Should receive an updated cart")
        allItemsExpectation.expectedFulfillmentCount = 3
        let countExpectation = expectation(description: "Should receive an updated product amount")
        countExpectation.expectedFulfillmentCount = 3

        var updatedCart = Cart()
        var updatedCount = 0

        sut.allItems
            .sink { cart in
                updatedCart = cart
                allItemsExpectation.fulfill()
            }
            .store(in: &cancellables)

        sut.amount
            .sink { count in
                updatedCount = count
                countExpectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        await sut.add(product)
        await sut.drop(product)

        // Then
        await fulfillment(of: [allItemsExpectation, countExpectation])
        XCTAssertFalse(updatedCart.keys.contains(product), "Product was not removed from the cart")
        XCTAssertEqual(updatedCart.count, 0, "Wrong cart size")
        XCTAssertEqual(updatedCount, 0)
    }
}
