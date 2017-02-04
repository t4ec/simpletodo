//
//  TodoItem.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import RealmSwift

class TodoItem: Object {
    dynamic var name = ""
    dynamic var finished = false
    
    let lists = LinkingObjects(fromType: TodoList.self, property: "items")
}
