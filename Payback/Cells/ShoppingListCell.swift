//
//  ShoppingListCell.swift
//  Payback
//
//  Created by Kaustubh on 16/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListCell: UITableViewCell {
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var itemLable: UILabel!
    var item : ShoppingItem? {
        didSet {
            
            guard let item = item else {
                return
            }
            self.itemLable.text = item.title
            if item.complete {
                checkBoxButton.setImage(UIImage(named: "check"), for: .normal)
            }
            else {
                checkBoxButton.setImage(UIImage(named:"uncheck"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.checkBoxButton.imageView?.contentMode = .scaleAspectFit
    }
}
