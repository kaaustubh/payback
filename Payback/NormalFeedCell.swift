//
//  NormalFeedCell.swift
//  Payback
//
//  Created by Kaustubh on 14/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class NormalFeedCell : UITableViewCell {
    @IBOutlet weak var headerLable: UILabel!
    
    @IBOutlet weak var sublineLable: UILabel!
    @IBOutlet weak var feedContentView: UIView!
    
    var feed : Feed? {
        didSet {
            
            guard let feed = feed else {
                return
            }
            headerLable.text = feed.headline
            sublineLable.text = feed.subline
            
        }
    }
    
}
