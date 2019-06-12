//
//  SeguesCheck.swift
//  MusicaTests
//
//  Created by Arslan Asim on 12/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//


import UIKit

extension UIViewController {
    func hasSegueWithIdentifier(id: String) -> Bool {
        let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject]
        let filtered = segues?.filter({ $0.value(forKey:"identifier") as? String == id })
        if let filter = filtered {
            return filter.count > 0
        }
        return false
    }
    func numberOfSegues() -> Int {
        let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject]
        return segues?.count ?? 0
    }
}
struct StorboardIDs {
    static let mainPage = "StoredAlbumsViewController"
    static let artistSearch = "ArtistSearchViewController"
    static let albumsList = "AlbumsListViewController"
    static let Details = "AlbumDetailsViewController"
}
