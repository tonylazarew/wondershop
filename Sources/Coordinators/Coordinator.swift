//
//  Coordinator.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }

    func start()
}
