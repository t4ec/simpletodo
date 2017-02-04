//
//  TodoList.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import Realm

class TodoList: RLMObject {
    dynamic var name = ""
    let items = List<ToDoItem>()
}
