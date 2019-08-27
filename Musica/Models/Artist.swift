//
//  Artist.swift
//  Musica
//
//  Created by Arslan Asim on 09/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift


/// Image sizes recieved from network
///
/// - small:
/// - medium:
/// - large:
/// - extralarge:
/// - mega:
enum ImageSize: String {
    case small
    case medium
    case large
    case extralarge
    case mega
}

final class ArtistRoot: Decodable {
    let artist: [Artist]
    let startPage: Int
    let totalResults: Int
    let startIndex: Int
    let itemsPerPage: Int
    let searchTerm: String
    private enum CodingKeys: String, CodingKey {
        case results
        case artistMatches = "artistmatches"
        case artist
        case query = "opensearch:Query"
        case startPage
        case totalResults = "opensearch:totalResults"
        case startIndex = "opensearch:startIndex"
        case itemsPerPage = "opensearch:itemsPerPage"
        case searchTerms
    }
    
    required init(from decoder:Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: CodingKeys.self)
        let results =  try parentContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        // get results
        let artistMatches = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .artistMatches)
        self.artist =  try artistMatches.decode([Artist].self, forKey: .artist)
        // get paginaiton Data
        let queryContainer = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .query)
        self.searchTerm = try queryContainer.decode(String.self, forKey: .searchTerms)
        if let startPage = try Int(queryContainer.decode(String.self, forKey: .startPage)),
            let totalResults = try Int(results.decode(String.self, forKey: .totalResults)),
            let startIndex = try Int(results.decode(String.self, forKey: .startIndex)),
            let itemsPerPage = try Int(results.decode(String.self, forKey: .itemsPerPage)){
            self.startPage = startPage
            self.totalResults = totalResults
            self.startIndex = startIndex
            self.itemsPerPage = itemsPerPage
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.startPage, CodingKeys.totalResults, CodingKeys.startIndex,CodingKeys.itemsPerPage], debugDescription: "Expecting string representation of Int"))
        }
        
    }

}
final class Artist: Decodable, Equatable {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.mbid == rhs.mbid
    }
    
    let name: String
    let mbid: String
    private let image: [ArtImage]
    
    // we don't need this, since name of key and server data is same
//    private enum CodingKeys: String, CodingKey {
//        case name
//        case mbid
//        case image
//    }
//    required init(from decoder:Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.mbid = try container.decode(String.self, forKey: .mbid)
//        self.image = try container.decode([ArtImage].self, forKey: .image)
//    }
    
    /// get image of given size, if no image of given size available, first image of array will return
    ///
    /// - Parameter size: size of image from ImageSize enum
    /// - Returns: optional ArtImage
    func getImageOf(size: ImageSize) -> ArtImage? {
        // get asked image from array
        if let imageVal = image.first(where: {$0.sizeString == size.rawValue}) {
            return imageVal
        }
        // if asked image can not be found return first image
        return image.first
    }
}
final class ArtImage: Object, Decodable {
    @objc dynamic var url: String = ""
    @objc dynamic var sizeString: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
    required convenience init(from decoder:Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: CodingKeys.url) ?? ""
        self.sizeString = try container.decode(String.self, forKey: .size)
    }
    var imageUrl: URL? {
        return URL(string: url)
    }
    var size: ImageSize? {
        return ImageSize(rawValue: sizeString)
    }
}
