//
//  NormalFeedCell.swift
//  Payback
//
//  Created by Kaustubh on 14/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ShoppingListParentCell: UITableViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shoppingItemsTableView: UITableView!
    var dataSource = ShoppingListDataSource()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func awakeFromNib() {
        self.shoppingItemsTableView.dataSource = dataSource
        self.shoppingItemsTableView.delegate = dataSource
        self.shoppingItemsTableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}



class NormalFeedCell : UITableViewCell {
    @IBOutlet weak var headerLable: UILabel!
    @IBOutlet weak var feedimageView: UIImageView!
    @IBOutlet weak var sublineLable: UILabel!
    
    @IBOutlet weak var feedContent: UIView!
    var feed : Feed? {
        didSet {
            
            guard let feed = feed else {
                return
            }
            headerLable.text = feed.headline
            sublineLable.text = feed.subline
            setFeedContent()
        }
    }
    
    func setFeedContent() {
        if self.feed?.type == .image {
            self.feedimageView.imageFromServerURL(urlString: feed!.data, PlaceHolderImage: UIImage())
        }
        else if self.feed?.type == .video {
            if let videoUrl = URL(string: self.feed!.data) {
                self.getThumbnailImageFromVideoUrl(url: videoUrl) { (thumbNailImage) in
                    self.feedimageView.image = thumbNailImage
                }
            }
            
        }
        
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
}


extension UIImageView {
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    
}
