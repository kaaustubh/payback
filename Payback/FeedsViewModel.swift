//
//  FeedViewModel.swift
//  Payback
//
//  Created by Kaustubh on 12/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

class FeedsViewModel{
    private let feeds: [Feed] = [Feed]()
    weak var dataSource : DataSource?
    weak var service: FeedServiceProtocol?
    var onErrorHandling : ((CustomError?) -> Void)?
    public init(dataSource: DataSource) {
        self.service = FeedService.shared
        self.dataSource = dataSource
        NotificationCenter.default.addObserver( self, selector: #selector(reloadShoppingList), name: NSNotification.Name(rawValue: "reloadtableview"),
        object: nil)
    }

    @objc private func reloadShoppingList(notification: NSNotification){
        if let fooOffset = self.dataSource?.data.value.firstIndex(where: {$0.type == .shopping_list}) {
            self.dataSource?.data.value.remove(at: fooOffset)
            self.dataSource?.data.value.append(LocalStorage.shared.shoppingListFeed())
            self.dataSource?.data.value.sort(by: { $0.score > $1.score})
        }
        
       }
    
    func fetchFeeds() {
        FeedService.shared.loadFeeds(completion: {[weak self] feeds,error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if error == nil, let feeds = feeds {
                    self.dataSource?.data.value = feeds
                    self.dataSource?.data.value.sort(by: { $0.score > $1.score})
                }
                else {
                    if let handler = self.onErrorHandling {
                        handler(error)
                    }
                }
            }
        })
    }
}
