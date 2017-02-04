//
//  ImageRow.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import Foundation
import Eureka

final class ImageRow: Row<ImageCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ImageCell>(nibName: "ImageCell")
    }
    
//    override func didSelect() {
//        deselect()
//    }
}
