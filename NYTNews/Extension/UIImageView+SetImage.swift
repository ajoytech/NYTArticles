//
//  UIImageView+SetImage.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 25/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    /**
     It will download image data from URL and set it to image view
     - Parameters:
     - url: url string to download image
     - Returns:
     */
    func setImage(from url: String) {
        if let cachedImage = imageCache.object(forKey: url as AnyObject){
            RunOnMainThread {
                self.image = cachedImage
            }
            return
        }
        
        RunInBackground {
            APIManager().downloadArticleImages(relativePath: url) { (result) in
                switch result {
                case .success(let data) :
                    guard let imageFromData = UIImage(data: data) else { return }
                    imageCache.setObject(imageFromData, forKey: url as AnyObject)
                    RunOnMainThread {
                        self.image = imageFromData
                    }
                case .failed( _) :
                    RunOnMainThread {
                        self.image = #imageLiteral(resourceName: "defaultImage")
                    }
                }
            }
        }
    }
}
