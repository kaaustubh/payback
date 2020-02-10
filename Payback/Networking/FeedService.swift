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
                        if feeds.count > 0 {
                            LocalStorage.shared.saveWebFeeds(feeds: feeds)
                        }
                    }
                    feeds.append(LocalStorage.shared.shoppingListFeed())
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
let webFeeds = "webfeeds"

class LocalStorage {
    static let shared = LocalStorage()
    let userDefaults = UserDefaults.standard
    
    func saveWebFeeds(feeds: [Feed]){
        saveData(data: feeds, for: webFeeds)
    }
    
    func localWebFeeds() -> [Feed] {
        var feeds = [Feed]()
        if let data = self.data(for: webFeeds), let localFeeds = (data as? [Feed]) {
            feeds = localFeeds
        }
        return feeds
    }
    
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
        self.saveData(data: feed, for: shoppingListKey)
    }
    
    func saveData(data: Any, for key: String) {
        do {
            var encodedData: Data!
            if data is Feed {
                encodedData = try JSONEncoder().encode(data as! Feed)
            }
            else {
                encodedData = try JSONEncoder().encode(data as! [Feed])
            }
            UserDefaults.standard.set(encodedData, forKey: key)
            userDefaults.synchronize()
        }
        catch {
            print("Error")
        }
    }
    
    func data(for key: String) -> Any? {
        do {
            if let feedData = UserDefaults.standard.data(forKey: key) {
                var data: Any!
                switch key {
                case webFeeds:
                    data = try JSONDecoder().decode([Feed].self, from: feedData)
                case shoppingListKey:
                    data = try JSONDecoder().decode(Feed.self, from: feedData)
                default:
                    print("Default")
                }
                return data
            }
        }
        catch {
            return nil
        }
        return nil
    }
}
