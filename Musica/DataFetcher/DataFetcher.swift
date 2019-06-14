//
//  NetworkHelper.swift
//  Musica
//
//  Created by Arslan Asim on 09/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - type typealias

typealias MusicaResponseBlock<T : Decodable> = (_ error: AppError?, _ response: T?) -> Void

/// App Error
///
/// - gernalError: simple error with description
enum AppError: Error {
    case gernalError(message: String)
    func getErrorMessage() -> String {
        switch self {
        case .gernalError( let message):
            return message
        }
    }
}

/// contains end points to be hit through out app
///
/// - artist: to get artists with search
/// - album: to get top albums from artist
/// - albumDetails: to get album details from album mbid
enum EndPoint: String {
    case artist = "artist.search"
    case album = "artist.getTopAlbums"
    case albumDetails = "album.getInfo"
}

/// data fetcher protocol will be used to mock api calls
protocol MusicaDataFetcherProtocol {
    
    /// one point entry to get all netwrok data
    ///
    /// - Parameters:
    ///   - method: EndPoint Enum
    ///   - queryParam: if extra param needed to sent to api call it will be passed through this
    ///   - completion: completion block called after data/error
    func fetchNetworkData<T: Decodable>(method: EndPoint, queryParam: [String: Any], completion: @escaping MusicaResponseBlock<T>)
}

final class DataFetcher: MusicaDataFetcherProtocol {
    
    private struct DataFetcherConstant {
        static let apiKey = "9e396f5ff83abc29b31401366c8fd479"
        static let musicaURL = "https://ws.audioscrobbler.com/2.0/"
        static let unknownResponse = NSLocalizedString("The server returned an unknown response.", comment: "The error message shown when the server produces something unintelligible.")
        static let urlNotGood = NSLocalizedString("URL requested is not good", comment: "The error message shown when server accessing url is not good.")
        static let format = "json"
    }
    
    /// fetch data from networks
    ///
    /// - Parameters:
    ///   - method: EndPoint Enum
    ///   - queryParam: if extra param needed to sent to api call it will be passed through this
    ///   - completion: completion block called after data/error
    func fetchNetworkData<T>(method: EndPoint, queryParam: [String : Any], completion: @escaping (AppError?, T?) -> Void) where T : Decodable {
        guard let url = URL(string: DataFetcherConstant.musicaURL) else {
            // incorporate error
            completion(AppError.gernalError(message: DataFetcherConstant.urlNotGood), nil)
            return
        }
        var params = [String : Any]()
        params["method"] = method.rawValue
        params["api_key"] = DataFetcherConstant.apiKey
        params["format"] = DataFetcherConstant.format
        params.merge(queryParam) { (current, _) in current }
        let request = Alamofire.request(url, method: .get, parameters: params)
        request.responseData { (response:DataResponse<Data>) in
            if let error = response.error { // if there is any error we will show it and get back
                completion(AppError.gernalError(message: error.localizedDescription), nil)
                return
            }
            guard let jsonData = response.data else {
                completion(AppError.gernalError(message: DataFetcherConstant.unknownResponse), nil)
                return
            }
            self.parseServerData(data: jsonData, completion: completion)
        }
    }
    
    /// parse network data
    ///
    /// - Parameters:
    ///   - data: netwrok data
    ///   - completion: completion block called after data/error
    private func parseServerData<T: Decodable>(data:Data, completion: MusicaResponseBlock<T>) {
        let decoder = JSONDecoder()
        do {
            let serverData = try decoder.decode(T.self, from: data)
            completion(nil, serverData)
        } catch let error {
            completion(AppError.gernalError(message: error.localizedDescription), nil)
        }
    }
}
