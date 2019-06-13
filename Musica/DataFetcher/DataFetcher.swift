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
enum AppError: Error {
    case gernalError(message: String)
    func getErrorMessage() -> String {
        switch self {
        case .gernalError( let message):
            return message
        }
    }
}

enum EndPoint: String {
    case artist = "artist.search"
    case album = "artist.getTopAlbums"
    case albumDetails = "album.getInfo"
}

protocol MusicaDataFetcherProtocol {
    func fetchNetworkData<T: Decodable>(method: EndPoint, queryParam: [String: Any], completion: @escaping MusicaResponseBlock<T>)
}

class DataFetcher: MusicaDataFetcherProtocol {
    private struct DataFetcherConstant {
        static let apiKey = "9e396f5ff83abc29b31401366c8fd479"
        static let musicaURL = "https://ws.audioscrobbler.com/2.0/"
        static let unknownResponse = NSLocalizedString("The server returned an unknown response.", comment: "The error message shown when the server produces something unintelligible.")
        static let urlNotGood = NSLocalizedString("URL requested is not good", comment: "The error message shown when server accessing url is not good.")
        static let format = "json"
    }
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
