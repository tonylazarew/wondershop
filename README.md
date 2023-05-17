Wondershop
==========

A simple shop app implementation on SwiftUI on top of a backend from [dummyjson.com](https://dummyjson.com).

# UI and screens

## Product list

The app starts with a product list screen, which will reveal itself once the loading from the backend is completed. User can scroll
through the list, the list will fetch more products from the backend as the user scrolls down. Every product item in the list
reveals a title, a brand name and a price (with a discount, if present).

## Product description

User can reveal an extended product description, including ratings, stock status and photos by tapping on a product item in the list.

Cart button in both product list and product description views can only either add an product to cart or completely drop
it from the cart. In order to change the specific order amount for a given product, a user needs to go to the cart screen.

## Cart screen

Cart screen is accessible by tapping a "Cart" navigation button on the top of the main product list screen. In the cart
a user can see individual products in the cart, along with their quantities, prices and a total order amount.

Amount of a specific product in the cart will not exceed the stock available. If a user goes from an amount of 1 to 0, the
product is then dropped from the cart.

User can tap on an individual product in the cart to go to the product description page.

# Architecture

## Views and view models

Each view has its own dedicated view model. This app sticks to the principle of having view models driving the views, with
the views being as simple as possible.

No special dependency injection technique was used for this project, and ultimately the view models instantiate each other
as needed. This approach has its pros and cons but it does work for a simple usecase like this.

The app's entry point view is `ProductList` which relies on its `ProductListViewModel` to be instantiated and retained
by the `App` instance.

## Models

There are two models defined:
* `Product`, represents a single product information
* `Cart`, a type alias for `OrderedDictionary` that holds `Product` as key and `ProductAmount` as value

The `OrderedDictionary` type was chosen so the app could keep the timeline of user actions with the cart.

## Repositories

Two main repositories are being used by the app"
* `CartStore`, an on-device storage for the cart contents. It's built on top of `UserDefaults` but that can be swapped out
if needed by creating a different implementation of `CartRepository` protocol.
* `ProductStore`, the store that provides product data to the app. It is implemented by `DummyJSONProductStore`.

## Services

The service implementation that is responsible for the cart is called `CartManagerImpl`.

`CartStateReadable` and `CartStateWriteable` protocols are defined in order to separate the access types to the cart.
Currently there's just one reader implementation in the app, the navigation button on the `ProductList` screen.
All the other users rely on both read and write operations.

# Configuration

The URL for DummyJSON is injected as a build setting, called `DUMMY_JSON_BASE_URL`.

# Testing

Having spent most of the time on the app itself, I've only added a few unit tests for `CartManager`.

# External packages

Wondershop relies on these external packages:
* `swift-collections`: Provides `OrderedDictionary` used as a storage for the cart
* `SDWebImageSwiftUI` (and `SDWebImage`): This library is employed to load and display product images
