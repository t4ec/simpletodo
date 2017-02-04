//
//  TodoItemsTableViewController.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import RealmSwift
import SKPhotoBrowser

class TodoItemsTableViewController: UITableViewController {

    let realm = try! Realm()
    var todoList: TodoList?
    
    var todoItems: Results<TodoItem> {
        get {
            return self.realm.objects(TodoItem.self).filter("%@ IN lists", todoList!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let list = todoList {
            navigationItem.title = list.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let addListVC = (UIApplication.shared.delegate as! AppDelegate).storyboard!.instantiateViewController(withIdentifier: "Add Edit Item") as! UINavigationController
        addListVC.modalPresentationStyle = .currentContext

        let topVC = addListVC.topViewController as! AddEditItemViewController
        topVC.todoList = todoList
        
        present(addListVC, animated: true, completion: nil)
    }

    @IBAction func showGallery(_ sender: UIBarButtonItem) {
        let imageItems = realm.objects(TodoItem.self).filter("image != nil AND %@ IN lists", todoList!)
        if imageItems.count > 0 {
            var photos: [SKPhoto] = []
            for item in imageItems {
                let path = FileManager.pathToFileInDocumentsDirectory(item.image!)
                photos.append(SKPhoto.photoWithImageURL(path.relativeString))
            }
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(0)
            present(browser, animated: true, completion: {})
        }
    }

}

// MARK: - Table view data source
extension TodoItemsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(todoItems.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo Item Cell", for: indexPath) as! TodoItemTableViewCell
        let todoItem = todoItems[indexPath.row]
        cell.title.text = todoItem.name
        cell.finished = todoItem.finished
        cell.indexPath = indexPath
        cell.itemDelegate = self
        return cell
    }
}

// MARK: - Table view delegate
extension TodoItemsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            todoItems[indexPath.row].removeImage()
            try! realm.write {
                realm.delete(todoItems[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addListVC = (UIApplication.shared.delegate as! AppDelegate).storyboard!.instantiateViewController(withIdentifier: "Add Edit Item") as! UINavigationController
        
        let topVC = addListVC.topViewController as! AddEditItemViewController
        topVC.todoItem = todoItems[indexPath.row]

        addListVC.modalPresentationStyle = .currentContext
        present(addListVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TodoItemTableViewCellDelegate
extension TodoItemsTableViewController: TodoItemTableViewCellDelegate {
    func changeItemStatus(for indexPath: IndexPath, finished: Bool) {
        let item = todoItems[indexPath.row]
        try! realm.write {
            item.finished = finished
        }
        // Reload cell to update button text
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
