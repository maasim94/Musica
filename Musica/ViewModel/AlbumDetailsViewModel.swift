//
//  AlbumDetailsViewModel.swift
//  Musica
//
//  Created by Arslan Asim on 11/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift
final class AlbumDetailsViewModel: NSObject {
    private let dataFetcher: MusicaDataFetcherProtocol
    var selectedAlbum: Album
    let realm: Realm!
    // MARK: - init
    init(dataFetcher: MusicaDataFetcherProtocol, album: Album, realm: Realm) {
        self.dataFetcher = dataFetcher
        self.selectedAlbum = album
        self.realm = realm
    }
    // MARK: - businsess logic
    func numberOfRows(of section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return selectedAlbum.tracks.count
    }
    let numberOfSections:Int = 2
    func getTrack(for index:Int) -> Track {
        return selectedAlbum.tracks[index]
    }
    var title:String {
        return selectedAlbum.name
    }
    func getAlbumDetails(completion:@escaping () -> Void) {
        let params: [String: Any] = ["mbid": selectedAlbum.mbid]
        dataFetcher.fetchNetworkData(method: .albumDetails, queryParam: params) { [weak self] (error: AppError?, albums: AlbumDetailsRoot?) in
            guard let strongSelf  = self else { return }
            if let error = error {
                Messages.showMessage(message: error.getErrorMessage(), theme: .error)
                completion()
                return
            }
            guard let albumObject = albums?.album else {
                completion()
                return }
            strongSelf.selectedAlbum = albumObject
            completion()
        }
    }
    func saveUnSaveAlbum(completion: (Bool) ->  Void) {
        if let databaseItem = realm.object(ofType: Album.self, forPrimaryKey: selectedAlbum.mbid) {
            try! realm.write {
                databaseItem.isFav = !databaseItem.isFav
                completion(databaseItem.isFav)
            }
        } else {
            try! realm.write {
                self.selectedAlbum.isFav = true
                realm.add(self.selectedAlbum, update: true)
                completion(true)
            }
        }
    }
}
