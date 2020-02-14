//
//  PaybackTests.swift
//  PaybackTests
//
//  Created by Kaustubh on 07/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import XCTest
@testable import Payback

class PaybackIntegrationTests: XCTestCase {

    let extractedExpr: LocalStorage = LocalStorage.shared
    let service = FeedService.shared
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTiles() {
        let postsExpectation = expectation(description: "Get Posts")
        _ = service.loadFeeds(completion: { feeds,error in
            if feeds != nil && feeds!.count > 1 {
                postsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testLocalFeeds() {
        let postsExpectation = expectation(description: "Get Posts")
        _ = service.loadFeeds(completion: {[weak self] feeds,error in
            guard let self = self else { return }
            let localFeeds = self.extractedExpr.localWebFeeds()
            if localFeeds.count > 0 {
                postsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testLocalShoppingListStorage() {
        let feed = extractedExpr.shoppingListFeed()
        XCTAssertTrue(feed.type == .shopping_list)
    }
        
    func testAddShopingListItemsAndSave() {
        
        let feed = extractedExpr.shoppingListFeed()
        feed.items = [ShoppingItem(title: "iPhone"), ShoppingItem(title: "iPhone"), ShoppingItem(title: "iPhone")]
        extractedExpr.saveShoppingList(feed: feed)
        
        let localFeed = LocalStorage.shared.shoppingListFeed()
        XCTAssertTrue(localFeed.items.count == 3)
        XCTAssertEqual(localFeed.items.first?.title, "iPhone")
        
    }

}
