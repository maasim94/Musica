//
//  ImageTableViewCell.swift
//  Musica
//
//  Created by Arslan Asim on 11/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgArt: UIImageView!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        cornerImageView()
        
        // Initialization code
    }
    private func cornerImageView() {
        imgArt.layer.cornerRadius = 10
        imgArt.clipsToBounds = true
        imgArt.layer.borderColor = UIColor.lightGray.cgColor
        imgArt.layer.borderWidth = 2
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            // scrolling up
            viewContainer.clipsToBounds = true
            bottomSpaceConstraint?.constant = -scrollView.contentOffset.y / 2
            topSpaceConstraint?.constant = scrollView.contentOffset.y / 2
        } else {
            // scrolling down
            topSpaceConstraint?.constant = scrollView.contentOffset.y
            viewContainer.clipsToBounds = false
        }
    }
    func configureCell(album: Album) {
        let placeholderImage =  #imageLiteral(resourceName: "coverImage") 
        if let imageData = album.getImageOf(size: .large), let url = URL(string: imageData.url) {
            imgArt.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            imgArt.image = placeholderImage
        }
        
    }
}
