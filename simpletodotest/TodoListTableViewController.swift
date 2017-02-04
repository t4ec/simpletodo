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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        let addListVC = (UIApplication.shared.delegate as! AppDelegate).storyboard!.instantiateViewController(withIdentifier: "Add Edit List") as! UINavigationController
        
        let topVC = addListVC.topViewController as! AddEditListViewController
        topVC.todoList = todoLists[indexPath.row]
        addListVC.modalPresentationStyle = .currentContext
        
        present(addListVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // Delete all nested items & list itself
            todoLists[indexPath.row].removeAllItems()
            try! realm.write {
                realm.delete(todoLists[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
        }
    }
}

// MARL: - Handle segues
extension TodoListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "Show Todo List Items":
            if let dvc = destination as? TodoItemsTableViewController {
                guard let todoListIndexPath = tableView.indexPathForSelectedRow else { return }
                let todoList = todoLists[todoListIndexPath.row]
                dvc.todoList = todoList
            }
        default:
            return
        }
    }
}
