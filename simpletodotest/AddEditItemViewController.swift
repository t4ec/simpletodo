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
import SKPhotoBrowser

class AddEditItemViewController: FormViewController {
    
    let realm = try! Realm()
    
    // If we have it - we are editing, otherwise - creating new list
    var todoItem: TodoItem?
    var todoList: TodoList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize form, add Name row
        form = Form()
        form
            +++ Section()
            <<< TextRow("Name") {
                $0.placeholder = "Item name"
            }
            +++ Section()
            <<< ImageRow("Image") {
                $0.hidden = Condition.function([], { [unowned self] form in
                    if let _ = self.todoItem?.image {
                        return false
                    }
                    return true
                })
            }.cellUpdate({ cell, row in
                cell.height = {return UITableViewAutomaticDimension }
                if let imageName = self.todoItem?.image {
                    if let image = FileManager.getImageFromDocumentsDirectory(imageName) {
                        row.value = image
                        cell.itemImageView.image = image
                    }
                }
            }).onCellSelection({ [unowned self] cell, row in
                if let imageName = self.todoItem?.image {
                    let imagePath = FileManager.pathToFileInDocumentsDirectory(imageName)
                    let image = SKPhoto.photoWithImageURL(imagePath.relativeString)
                    let browser = SKPhotoBrowser(photos: [image])
                    browser.initializePageIndex(0)
                    self.present(browser, animated: true, completion: {})
                }
                row.deselect()
            })

            <<< ButtonRow("Add Image") {
                $0.title = "Add Image"
                $0.hidden = Condition.function([], { [unowned self] form in
                    if self.todoItem == nil || self.todoItem?.image != nil {
                        return true
                    }
                    return false
                })
            }.onCellSelection({ [unowned self] cell, row in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            })
            
            <<< ButtonRow("Change Image") {
                $0.title = "Change Image"
                $0.hidden = Condition.function([], { [unowned self] form in
                    if let _ = self.todoItem?.image {
                        return false
                    }
                    return true
                })
            }.onCellSelection({ cell, row in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            })
        
            <<< ButtonRow("Remove Image") {
                $0.title = "Remove Image"
                $0.hidden = Condition.function([], { [unowned self] form in
                    if let _ = self.todoItem?.image {
                        return false
                    }
                    return true
                })
            }.onCellSelection({ [unowned self] cell, row in
                self.removeImage()
            })
        
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


extension AddEditItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Remove previously picked image
        removeImage()
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageName = UUID().uuidString

        // Save image to DB only if saving file succeeded
        if let _ = FileManager.saveImageToDocumentsDirectory(imageName, image: image) {
            try! realm.write {
                todoItem!.image = imageName
            }
        }
        dismiss(animated: true, completion: nil)
        updateHiddenRows()
    }
    
    fileprivate func updateHiddenRows() {
        for row in form.allRows {
            row.evaluateHidden()
        }
    }
    
    fileprivate func removeImage() {
        if let image = todoItem?.image {
            FileManager.removeImageFromDocumentsDirectory(image)
            try! realm.write {
                todoItem!.image = nil
            }
        }
        updateHiddenRows()
    }
}
