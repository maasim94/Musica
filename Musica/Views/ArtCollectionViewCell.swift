//
//  ArtCollectionViewCell.swift
//  Musica
//
//  Created by Arslan Asim on 11/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit

class ArtCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgArt: UIImageView!
    @IBOutlet weak var lblAlbumName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        cornerContainerView()
        // Initialization code
    }
    private func cornerContainerView() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 2
    }
    func configureCellFor(album: Album) {
        lblAlbumName.text = album.name
        let placeholderImage = UIImage(named: "music-player")
        if let imageData = album.getImageOf(size: .extralarge), let url = URL(string: imageData.url) {
            imgArt.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            imgArt.image = placeholderImage
        }
    }

}
