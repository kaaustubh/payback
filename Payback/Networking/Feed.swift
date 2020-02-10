//
//  Feed.swift
//  Payback
//
//  Created by Kaustubh on 07/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

struct FeedResponse: Codable{
    var tiles: [Feed]?
}

enum FeedType: String, Codable {
    case image = "image"
    case video = "video"
    case website = "website"
    case shopping_list = "shopping_list"
}

class Feed: NSObject, Codable {
    var name: String = ""
    var headline: String = ""
    var subline: String = ""
    var data: String = ""
    var score: Int = -1
    var items: [String] = [String]()
    var type: FeedType = .image
    
    init(jsonFeed: [String: Any]) {
        if let data = jsonFeed["name"] as? String {
            self.name = data
            if let type = FeedType(rawValue: data) {
                self.type = type
            }
        }
        if let data = jsonFeed["data"] as? String{
            self.data = data
        }
        if let data = jsonFeed["score"] as? NSNumber{
            self.score = Int(truncating: data)
        }
        if let data = jsonFeed["headline"] as? String{
            self.headline = data
        }
        if let data = jsonFeed["subline"] as? String{
            self.subline = data
        }
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.headline, forKey: "headline")
        aCoder.encode(self.subline, forKey: "subline")
        aCoder.encode(self.data, forKey: "data")
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.items, forKey: "items")
        aCoder.encode(self.type.rawValue, forKey: "type")
    }
    
    required init(coder aDecoder: NSCoder)
    {
        if let data = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = data
        }
        
        if let data = aDecoder.decodeObject(forKey: "headline") as? String {
            self.headline = data
        }
        
        if let data = aDecoder.decodeObject(forKey: "subline") as? String {
            self.subline = data
        }
        
        if let data = aDecoder.decodeObject(forKey: "data") as? String {
            self.data = data
        }
        if let data = aDecoder.decodeObject(forKey: "score") as? Int {
            self.score = data
        }
        
        if let data = aDecoder.decodeObject(forKey: "items") as? [String] {
            self.items = data
        }
        
        if let data = aDecoder.decodeObject(forKey: "type") as? String {
            self.type = FeedType(rawValue: data)!
        }
        
    }
}

