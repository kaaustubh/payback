//
//  ViewController.swift
//  Payback
//
//  Created by Kaustubh on 07/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    let dataSource = DataSource()
    
    lazy var viewModel : FeedsViewModel = {
        let viewModel = FeedsViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        //This also should not be done, there  should be a different delegate class  to handle tableview deletation
        self.tableView.delegate = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        self.viewModel.fetchFeeds()
        
        
    }
    
    @objc private func reloadTableView(notification: NSNotification){
        self.tableView.reloadData()
    }

    

}

