//
//  AddEditListViewController.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit

class AddEditListViewController: UIViewController {
    @IBOutlet weak var customNavigationItem: UINavigationItem!
    var addingList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if addingList {
            customNavigationItem.title = "Add list"
        } else {
            customNavigationItem.title = "Edit list"
        }
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
