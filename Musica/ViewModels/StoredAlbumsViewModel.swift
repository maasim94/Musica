//
//  StoredAlbumsViewModel.swift
//  Musica
//
//  Created by Arslan Asim on 12/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift

final class StoredAlbumsViewModel {
    private var savedAlbums: Results<Album>? {
        didSet {
            refreshCollectionData?()
        }
    }
    var realmChangesToken:NotificationToken?
    // MARK: - init
    
    /// init ViewModel
    ///
    /// - Parameter realm: Realm Object
    init(realm: Realm) {
        savedAlbums = realm.objects(Album.self).filter("isFav == true")
        realmChangesToken = realm.observe { [weak self] (notification, realm) in
            self?.savedAlbums = realm.objects(Album.self).filter("isFav == true")
        }
    }
    deinit {
        realmChangesToken = nil
    }
    // output
    var refreshCollectionData: (() -> Void)?
    // MARK: - businsess logic
    var numberOfRows: Int {
        return savedAlbums?.count ?? 0
    }
    let numberOfSections:Int = 1
    
    /// get Album to show on cell
    ///
    /// - Parameter index: item value of cell
    /// - Returns: album value 
    func getAlbum(for index:Int) -> Album? {
        return savedAlbums?[index]
    }
    var isDataEmpty: Bool {
        guard let data = savedAlbums else { return true }
        return data.count == 0 ? true : false
    }

}
