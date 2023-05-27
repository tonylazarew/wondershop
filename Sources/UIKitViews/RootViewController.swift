//
//  RootViewController.swift
//  Wondershop
//
//  Created by Anton Lazarev on 27/05/2023.
//

import UIKit

final class RootViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let label = UILabel()
//        label.text = "UIKit be here"
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
//    }

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set label properties
        label.text = "UIKit Wondershop be here!\nEventually..."
        label.numberOfLines = 2
        label.textAlignment = .center

        // Add label to the view
        view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Size the label to fit its content
        label.sizeToFit()

        // Calculate coordinates for centering the label
        let xPos = (view.frame.width / 2) - (label.frame.width / 2)
        let yPos = (view.frame.height / 2) - (label.frame.height / 2)

        // Update the label frame
        label.frame.origin = CGPoint(x: xPos, y: yPos)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
