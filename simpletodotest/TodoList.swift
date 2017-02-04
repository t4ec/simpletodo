//
//  TodoList.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import RealmSwift

class TodoList: Object {
    dynamic var name = ""
    let items = List<TodoItem>()
    
    func removeAllItems() {
        for item in items {
            item.removeImage()
        }
        try! realm!.write {
            // Delete all nested items & list itself
            realm!.delete(items)
        }
    }
}
