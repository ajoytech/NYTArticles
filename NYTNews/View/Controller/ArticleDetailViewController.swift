//
//  ArticleDetailViewController.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 25/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation
import UIKit

class ArticleDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailView: UITextView!
    
    var articleImageUrl: String?
    var articleTitle: String?
    var articleDetail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        if let imageUrl = articleImageUrl {
            imageView.setImage(from: imageUrl)
        }
        titleView.text = articleTitle
        detailView.text = articleDetail
        
    }
}
