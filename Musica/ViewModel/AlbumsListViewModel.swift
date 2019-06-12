//
//  AlbumsListViewModel.swift
//  Musica
//
//  Created by Arslan Asim on 11/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift

final class AlbumsListViewModel {
    private let dataFetcher: MusicaDataFetcherProtocol
    private let selectedArtist: Artist
    private var albumData: AlbumRoot? // keep this term to have paginate
    private var currentNetwork: NetworkState = .inital
    private var currentAlbums: [Album] = [] {
        didSet {
            refreshTableData?()
        }
    }
    private let realm = try! Realm()
    // output
    var refreshTableData: (() -> Void)?
    // MARK: - init
    init(dataFetcher: MusicaDataFetcherProtocol, artist: Artist) {
        self.dataFetcher = dataFetcher
        self.selectedArtist = artist
    }
    // MARK: - businsess logic
    var numberOfRows: Int {
        return currentAlbums.count
    }
    let numberOfSections:Int = 1
    var title:String {
        return selectedArtist.name
    }
    func getAlbum(for index:Int) -> (album: Album, isFav:Bool) {
        let album = currentAlbums[index]
        var isFav = false
        if let databaseObj = realm.object(ofType: Album.self, forPrimaryKey: album.mbid)  {
            isFav = databaseObj.isFav
        }
        album.isFav = isFav
        return (album, isFav)
    }
    // MARK: - pagination
    func askForNextPage() {
        guard let data = albumData, currentNetwork == .finished else { return  }
        if  data.currentPage < data.totalPages {
            performSearchRequest(mbid: selectedArtist.mbid, page: data.currentPage + 1, appendResults: true)
        }
    }
    // MARK: - api call
    func getAlbumsForArtist() {
        performSearchRequest(mbid: selectedArtist.mbid)
    }
    private func performSearchRequest(mbid: String, page: Int = 1, appendResults: Bool = false) {
        currentNetwork = .progress
        let params: [String: Any] = ["mbid": mbid, "page": page]
        dataFetcher.fetchNetworkData(method: .album, queryParam: params) { [weak self] (error: AppError?, albums: AlbumRoot?) in
            guard let strongSelf  = self else { return }
            strongSelf.albumData = albums
            strongSelf.currentNetwork = .finished
            if let error = error {
                Messages.showMessage(message: error.getErrorMessage(), theme: .error)
                return
            }
            guard let albumArray = albums?.album else { return }
            if appendResults {
                strongSelf.currentAlbums.append(contentsOf: albumArray)
            } else {
                strongSelf.currentAlbums =  albumArray
            }
            
        }
    }
    
}
