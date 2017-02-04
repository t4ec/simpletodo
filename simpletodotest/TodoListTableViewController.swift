//
//  TodoListTableViewController.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import Realm

class TodoListTableViewController: UITableViewController {
    
    var todoLists: RLMArray {
        get {
            return TodoList.allObjects()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension TodoListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(todoLists.count())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo List Cell", for: indexPath) as! TodoListTableViewCell
        let todoList = todoLists.objectAtIndex(indexPath.row["name"]) as TodoList
        cell.title = todoList.name
    }
}
