//
//  AddEditItemViewController.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddEditItemViewController: FormViewController {
    
    let realm = try! Realm()
    
    // If we have it - we are editing, otherwise - creating new list
    var todoItem: TodoItem?
    var todoList: TodoList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize form, add Name row
        form = Form()
        form +++ Section() <<< TextRow("Name") {
            $0.placeholder = "Item name"
        }
        
        if let list = todoItem {
            navigationItem.title = "Edit item"
            let nameRow = form.rowBy(tag: "Name") as! TextRow
            nameRow.value = list.name
        } else {
            navigationItem.title = "Add item"
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        var newName = (form.rowBy(tag: "Name") as! TextRow).value
        
        // We do not want empty names for lists
        if newName == nil || newName?.characters.count == 0 {
            newName = "No name"
        }
        
        try! realm.write {
            if let item = todoItem {
                item.name = newName!
            } else {
                todoItem = TodoItem(value: ["name": newName!])
                todoList?.items.append(todoItem!)
                realm.add(todoItem!)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
