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
    }
    
    func addToShoppingList(item: String) {
        
    }
    
    func fetchFeeds() {
        FeedService.shared.loadFeeds(completion: {[weak self] feeds,error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if error == nil, let feeds = feeds {
                    self.dataSource?.data.value = feeds
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
