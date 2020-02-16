//
//  ShoppingListDataSource.swift
//  Payback
//
//  Created by Kaustubh on 15/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var feed: Feed = LocalStorage.shared.shoppingListFeed()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppingListCell
        cell.item = feed.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feed.items[indexPath.row].complete = true
        LocalStorage.shared.saveShoppingList(feed: feed)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
