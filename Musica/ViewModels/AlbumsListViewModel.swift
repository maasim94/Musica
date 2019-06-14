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
    let realm = try! Realm()
    var realmChangesToken:NotificationToken?
    // output
    var refreshTableData: (() -> Void)?
    // MARK: - init
    
    /// init viewmodel
    ///
    /// - Parameters:
    ///   - dataFetcher: network data fetcher
    ///   - artist: artist for which albums to get
    init(dataFetcher: MusicaDataFetcherProtocol, artist: Artist) {
        self.dataFetcher = dataFetcher
        self.selectedArtist = artist
        realmChangesToken = realm.observe { [weak self] (notification, realm) in
            self?.refreshTableData?()
        }
    }
    deinit {
        realmChangesToken = nil
    }
    // MARK: - businsess logic
    var numberOfRows: Int {
        return currentAlbums.count
    }
    let numberOfSections:Int = 1
    var title:String {
        return selectedArtist.name
    }
    
    /// get Album info for row, will check for fav and send return album
    ///
    /// - Parameter index: row number
    /// - Returns: album for sent row
    func getAlbum(for index:Int) -> Album {
        let album = currentAlbums[index]
        var isFav = false
        if let databaseObj = realm.object(ofType: Album.self, forPrimaryKey: album.mbid)  {
            isFav = databaseObj.isFav
        }
        album.isFav = isFav
        return album
    }
    // MARK: - pagination
    func askForNextPage() {
        guard let data = albumData, currentNetwork == .finished else { return  }
        if  data.currentPage < data.totalPages {
            performSearchRequest(mbid: selectedArtist.mbid, page: data.currentPage + 1)
        }
    }
    // MARK: - api call
    
    func getAlbumsForArtist() {
        performSearchRequest(mbid: selectedArtist.mbid)
    }
    
    /// perfrom network call
    ///
    /// - Parameters:
    ///   - mbid: id of artist
    ///   - page: page of call , default to 1
    private func performSearchRequest(mbid: String, page: Int = 1) {
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
            strongSelf.currentAlbums.append(contentsOf: albumArray)
        }
    }
    
}
