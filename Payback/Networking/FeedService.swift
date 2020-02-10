//
//  FeedService.swift
//  Payback
//
//  Created by Kaustubh on 07/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

class FeedService {
    
    private let client = NetworkEngine(baseUrl: "https://firebasestorage.googleapis.com/v0/b/payback-test.appspot.com/o/feed.json?alt=media&token=0f3f9a33-39df-4ad2-b9df-add07796a0fa")
    
    @discardableResult
    func loadFeeds(completion: @escaping ([Feed]?, CustomError?) -> ()) -> URLSessionDataTask? {
        let params: JSON = ["cache-control": "no-cache"]
        
        return client.load(path: "", method: .get, params: params) { result, error in
            if (error != nil) {
                completion(nil, error)
            }
            else if (result != nil) {
                do {
                    var feeds = [Feed]()
                    let jsonObj: AnyObject = try JSONSerialization.jsonObject(with: result as! Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject
                    
                    if let fobs = jsonObj.value(forKey: "tiles"){
                       for jsonFeed in fobs as! NSArray {
                            let feed = Feed(jsonFeed: jsonFeed as! [String : Any])
                            feeds.append(feed)
                        }
                    }
                    
                    //Somehow this doesnt work because of \ and \n
//                    let postResponse = try JSONDecoder().decode(FeedResponse.self, from: strData as! Data)
                    
                    completion(feeds, nil)
                }
                catch {
                    completion(nil, CustomError(code: 405, type: "Corrupted data", message: "Data is corrupt"))
                }
                
            }
            else {
                completion(nil, CustomError(code: 405, type: "NoResult", message: "No results found"))
            }
        }
    }
    
//    private func shoppingList() -> Feed {
//
//    }
}

let shoppingListKey = "shopping_list"

class LocalStorage {
    static let shared = LocalStorage()
    let userDefaults = UserDefaults.standard
    
    func shoppingListFeed() -> Feed {
        var feed: Feed!
        if let data = self.data(for: shoppingListKey) {
            feed = data as? Feed
        }else {
            feed = Feed(jsonFeed: ["name": "shopping_list"])
        }
        
        return feed
    }
    
    func saveShoppingList(feed: Feed) {
        self.saveData(data: feed, for: "shopping_list")
    }
    
    func saveData(data: Any, for key: String) {
        do {
            let encoded = try JSONEncoder().encode(data as! Feed)
            UserDefaults.standard.set(encoded, forKey: shoppingListKey)
            userDefaults.synchronize()
        }
        catch {
            print("Error")
        }
    }
    
    func data(for key: String) -> Any? {
        do {
            if let feedData = UserDefaults.standard.data(forKey: shoppingListKey) {
                let feed: Feed = try JSONDecoder().decode(Feed.self, from: feedData)
                return feed
            }
        }
        catch {
            return nil
        }
        return nil
    }
}
