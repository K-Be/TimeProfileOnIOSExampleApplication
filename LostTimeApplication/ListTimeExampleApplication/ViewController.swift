//
//  ViewController.swift
//  LostTimeApplication
//
//  Created by Andrew Romanov on 01.11.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var openTableButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Push to open"

        self.openTableButton.addTarget(self, action: #selector(openTableAction(_:)), for: .touchUpInside)
    }

    @objc func openTableAction(_ sender: Any?) {
        let tableController = TableViewController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(tableController, animated: true)
    }

}

