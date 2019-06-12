//
//  ArtistTableViewCell.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import AlamofireImage

class ArtTableViewCell: UITableViewCell {

    @IBOutlet weak var imgArt: UIImageView!
    @IBOutlet weak var lblArtName: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var heartIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellFor(artist: Artist) {
        lblArtName.text = artist.name
        let placeholderImage = UIImage(named: "musician")
        if let imageData = artist.getImageOf(size: .medium), let url = URL(string: imageData.url) {
            imgArt.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            imgArt.image = placeholderImage
        }
        heartIcon.isHidden = true
    }
    func configureCellFor(album: Album, isFav: Bool) {
        lblArtName.text = album.name
        let placeholderImage = UIImage(named: "music-player")
        if let imageData = album.getImageOf(size: .medium), let url = URL(string: imageData.url) {
            imgArt.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            imgArt.image = placeholderImage
        }
        heartIcon.isHidden = !isFav
    }
    func configureCellFor(track: Track) {
        
        lblArtName.text = track.name
        imgArt.image = UIImage(named: "music-player")
        heartIcon.isHidden = true
        arrowIcon.isHidden = true
    }
    
}
