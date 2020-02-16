//
//  DataSource.swift
//  Payback
//
//  Created by Kaustubh on 13/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class DataSource: GenericDataSource<Feed>, UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feed = self.data.value[indexPath.row]
        switch feed.type {
        case .image, .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageFeedCell", for: indexPath) as! NormalFeedCell
            cell.feed = feed
            return cell
        case .website:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebFeedCell", for: indexPath) as! WebFeedCell
            cell.feed = feed
            return cell
            
        case .shopping_list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingList", for: indexPath) as! ShoppingListParentCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = self.data.value[indexPath.row]
        if feed.type == .video {
            if let url = URL(string: feed.data) {
                self.playVideo(url: url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let feed = self.data.value[indexPath.row]
        if feed.type == .shopping_list {
            var height = 60
            height += feed.items.count * 44
            return CGFloat(height)
        }
        return 270
    }
    
    // this is not the place to play a video, it should have been done by ViewModel, but I couldnt figure out a way to do that.
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        if let topMostcontroller = self.topMostController() {
            topMostcontroller.present(playerViewController, animated: true, completion: {
                playerViewController.player!.play()
            })
        }
    }
    
    func topMostController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        guard let window = keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        
        return topController
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


