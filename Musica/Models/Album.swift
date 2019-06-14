//
//  Album.swift
//  Musica
//
//  Created by Arslan Asim on 09/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift


final class AlbumRoot: Decodable {
    let album: [Album]
    let currentPage: Int
    let itemsPerPage: Int
    let totalPages: Int
    let totalResults: Int
    private enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
        case album
        case pagiantion = "@attr"
    }
    private enum PageCodingKeys: String, CodingKey {
        case page
        case perPage
        case totalPages
        case total
    }
    
    required init(from decoder:Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: CodingKeys.self)
        let results =  try parentContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .topAlbums)
        self.album =  try results.decode([Album].self, forKey: .album)
        // get paginaiton Data
        let queryContainer = try results.nestedContainer(keyedBy: PageCodingKeys.self, forKey: .pagiantion)
        if let page = try Int(queryContainer.decode(String.self, forKey: .page)),
            let perPage = try Int(queryContainer.decode(String.self, forKey: .perPage)),
            let totalPages = try Int(queryContainer.decode(String.self, forKey: .totalPages)),
            let total = try Int(queryContainer.decode(String.self, forKey: .total)) {
            self.currentPage = page
            self.itemsPerPage = perPage
            self.totalPages = totalPages
            self.totalResults = total
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [PageCodingKeys.page, PageCodingKeys.perPage, PageCodingKeys.totalPages,PageCodingKeys.total], debugDescription: "Expecting string representation of Int"))
        }
    }
    
}
final class AlbumDetailsRoot: Decodable {
    let album: Album
}
final class Album: Object, Decodable {
    @objc dynamic var name: String = ""
    @objc dynamic var mbid: String = ""
    @objc dynamic var isFav: Bool = false
    dynamic let image: List<ArtImage>  = List<ArtImage>()
    dynamic let tracks: List<Track>  = List<Track>()
    private enum CodingKeys: String, CodingKey {
        case name
        case mbid
        case image
        case playcount
        // coding for tracks
        case tracks
        case track
    }
    override static func primaryKey() -> String? {
        return "mbid"
    }
    required convenience init(from decoder:Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid) ?? ""
        if let artImage = try container.decodeIfPresent(Array<ArtImage>.self, forKey: .image) {
            self.image.append(objectsIn: artImage)
        }
        //tracks
        if let tracksContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks), let trackArray = try tracksContainer.decodeIfPresent(Array<Track>.self, forKey: .track) {
            self.tracks.append(objectsIn: trackArray)
        }
    }
    
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
