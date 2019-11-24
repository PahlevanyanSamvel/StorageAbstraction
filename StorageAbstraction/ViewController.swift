//
//  ViewController.swift
//  StorageAbstraction
//
//  Created by Samvel on 9/12/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.borderColor = UIColor.blue.cgColor
    }

    @IBAction func storageChanged(_ sender: UISegmentedControl) {
        StorageManager.currentStorageType = StorageType(rawValue: sender.selectedSegmentIndex) ?? .realm
    }
    
}
