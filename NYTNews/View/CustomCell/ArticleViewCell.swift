//
//  ArticleViewCell.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import UIKit

class ArticleViewCell: UITableViewCell {

    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var articleCellContentView: UIView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDetail: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        self.articleCellContentView.layer.borderWidth = 0.5
        self.articleCellContentView.layer.borderColor = UIColor.clear.cgColor
        self.articleCellContentView.layer.masksToBounds = true
        
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        
        self.selectionStyle = .none
    }
    
    
    func setData(with articleCellViewModel: ArticleCellViewModel?) {
        if let cellModel = articleCellViewModel {
            spinnerView.stopAnimating()
            articleTitle.text = cellModel.title
            articleDetail.text = cellModel.description
            if let imageUrl = cellModel.imageLink {
                articleImage.setImage(from: imageUrl)
            }
        }else {
            spinnerView.startAnimating()
        }
    }
}
