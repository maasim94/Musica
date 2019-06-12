//
//  ArtistSearchViewModel.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit

enum NetworkState {
    case inital
    case progress
    case finished
}

final class ArtistSearchViewModel {
    // MARK: - properties
    private let dataFetcher: MusicaDataFetcherProtocol
    private var artistData: ArtistRoot? // keep this term to have paginate
    private var currentNetwork: NetworkState = .inital
    private var currentArtists: [Artist] = [] {
        didSet {
            refreshTableData?()
        }
    }
    // output
    var refreshTableData: (() -> Void)?
    // MARK: - init
    init(dataFetcher: MusicaDataFetcherProtocol) {
        self.dataFetcher = dataFetcher
    }
    // MARK: - businsess logic
    var numberOfRows: Int {
        return currentArtists.count
    }
    let numberOfSections:Int = 1
    func getArtist(for index:Int) -> Artist {
        return currentArtists[index]
    }
    // MARK: - pagination
    func askForNextPage() {
        guard let data = artistData, currentNetwork == .finished else { return  }
        if data.startPage * data.itemsPerPage < data.totalResults {
            performSearchRequest(name: data.searchTerm, appendResults: true)
        }
    }
    // MARK: - api call
    func getArtistForQuery(name: String) {
        artistData = nil
        currentArtists.removeAll()
        performSearchRequest(name: name)
    }
    private func performSearchRequest(name: String, appendResults: Bool = false) {
        currentNetwork = .progress
        var page = 1
        if appendResults {
             page = (artistData?.startPage ?? 0) + 1
        }
        let params: [String: Any] = ["artist": name, "page": page]
        dataFetcher.fetchNetworkData(method: .artist, queryParam: params) { [weak self] (error: AppError?, artists: ArtistRoot?) in
            guard let strongSelf  = self else { return }
            strongSelf.artistData = artists
            strongSelf.currentNetwork = .finished
            if let error = error {
                Messages.showMessage(message: error.getErrorMessage(), theme: .error)
                return
            }
            guard let artists = artists?.artist else { return }
            if appendResults {
                strongSelf.currentArtists.append(contentsOf: artists)
            } else {
                strongSelf.currentArtists =  artists
            }
            
        }
    }
    
}
