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
    @IBOutlet weak var stackListening: UIStackView!
    @IBOutlet weak var stackParent: UIStackView!
    @IBOutlet weak var lblListening: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessibilityIdentifier = AccessibilityIdentifiers.artTableViewCell
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellFor(artist: Artist) {
        lblArtName.text = artist.name
        let placeholderImage =  #imageLiteral(resourceName: "musician.png")
        if let imageData = artist.getImageOf(size: .medium), let url = URL(string: imageData.url) {
            imgArt.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            imgArt.image = placeholderImage
        }
        lblListening.text = artist.listeners
        heartIcon.isHidden = true
    }
    func configureCellFor(album: Album) {
        lblArtName.text = album.name
        let placeholderImage = #imageLiteral(resourceName: "music-player.png")
        if let imageData = album.getImageOf(size: .medium), let url = URL(string: imageData.url) {
            imgArt.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            imgArt.image = placeholderImage
        }
        heartIcon.isHidden = !album.isFav
        lblListening.text = album.playcount?.playcount
    }
    func configureCellFor(track: Track) {
        
        lblArtName.text = track.name
        imgArt.image = #imageLiteral(resourceName: "music-player.png") 
        heartIcon.isHidden = true
        arrowIcon.isHidden = true
        stackListening.isHidden = true
        stackParent.removeArrangedSubview(stackListening)
    }
    
}
