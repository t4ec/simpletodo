//
//  TodoItemTableViewCell.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Hue

class TodoItemTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var title: UILabel!
    var indexPath: IndexPath?
    var itemDelegate: TodoItemTableViewCellDelegate?

    var finished = false {
        didSet {
            if finished {
                self.title.textColor = UIColor.lightGray
            } else {
                self.title.textColor = UIColor.black
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
}

extension TodoItemTableViewCell: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        switch direction {
        case .leftToRight:
            let button = MGSwipeButton(title: finished ? "Uncheck" : "Check", backgroundColor: UIColor.clear, callback: { [unowned self] senderCell -> Bool in
                self.finished = !self.finished
                
                // Update item status in DB using TodoItemsTableViewController as delegate
                self.itemDelegate?.changeItemStatus(for: self.indexPath!, finished: self.finished)
                return true
            })
            button.setTitleColor(UIColor(hex: "0B6AFF"), for: .normal)
            button.isEnabled = true
            swipeSettings.transition = .drag
            expansionSettings.threshold = 1.5
            expansionSettings.buttonIndex = 0
            expansionSettings.fillOnTrigger = true
            leftExpansion = expansionSettings
            return [button]
        default: return []
        }
    }
}

protocol TodoItemTableViewCellDelegate {
    func changeItemStatus(for indexPath: IndexPath, finished: Bool)
}


