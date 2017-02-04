//
//  ImageCell.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import Eureka

class ImageCell: Cell<UIImage>, CellType   {
    
    @IBOutlet weak var itemImageView: UIImageView!

    override func setup() {
        height = { return 0 }
        itemImageView.contentMode = .scaleAspectFit
    }
    
    override func update() {
        itemImageView.image = row.value
    }
}
