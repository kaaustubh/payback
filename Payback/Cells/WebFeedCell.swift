//
//  WebFeedCell.swift
//  Payback
//
//  Created by Kaustubh on 14/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebFeedCell:  NormalFeedCell {
    
    @IBOutlet weak var webView: WKWebView!
    override func setFeedContent() {
        if let feed = feed, let url = URL(string: feed.data) {
            self.webView.load(URLRequest(url: url))
        }
    }
}
