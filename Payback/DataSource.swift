//
//  DataSource.swift
//  Payback
//
//  Created by Kaustubh on 13/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class DataSource: GenericDataSource<Feed>, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return data.value.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = self.data.value[indexPath.row]
        if feed.type != .shopping_list {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalFeedCell", for: indexPath) as! NormalFeedCell
            cell.feed = feed
            return cell
        }
        
        return UITableViewCell()
       }
}

class DynamicValue<T> {
    
    typealias CompletionHandler = ((T) -> Void)
    
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
}


class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}


