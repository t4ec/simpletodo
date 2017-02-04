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
    dynamic var image: String?
    
    let lists = LinkingObjects(fromType: TodoList.self, property: "items")
    
    func removeImage() {
        // Remove image file
        try! realm!.write {
            if let image = self.image {
                FileManager.removeImageFromDocumentsDirectory(image)
                self.image = nil
            }
        }
    }
}
