//
//  TodoListTableViewController.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var todoLists: Results<TodoList> {
        get {
            return self.realm.objects(TodoList.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    @IBAction func addList(_ sender: UIBarButtonItem) {
        let addListVC = (UIApplication.shared.delegate as! AppDelegate).storyboard!.instantiateViewController(withIdentifier: "Add Edit List") as! UINavigationController
        addListVC.modalPresentationStyle = .currentContext

        present(addListVC, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension TodoListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(todoLists.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo List Cell", for: indexPath) as! TodoListTableViewCell
        let todoList = todoLists[indexPath.row]
        cell.title.text = todoList.name
        return cell
    }
}

// MARK: - Table view delegate
extension TodoListTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        let addListVC = (UIApplication.shared.delegate as! AppDelegate).storyboard!.instantiateViewController(withIdentifier: "Add Edit List") as! UINavigationController
        
        // Set "adding" flag on top view controller
        let topVC = addListVC.topViewController as! AddEditListViewController
        topVC.todoList = todoLists[indexPath.row]
        addListVC.modalPresentationStyle = .currentContext
        
        present(addListVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            try! realm.write {
                realm.delete(todoLists[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
        }
    }
}
