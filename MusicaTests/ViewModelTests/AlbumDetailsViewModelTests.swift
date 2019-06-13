//
//  AlbumDetailsViewModelTests.swift
//  MusicaTests
//
//  Created by Arslan Asim on 13/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import XCTest
@testable import Musica
@testable import RealmSwift

class AlbumDetailsViewModelTests: XCTestCase {

    var sut: AlbumDetailsViewModel!
    var mockDataFetcher: MockAlbumDetailsFetcher!
    var testRealm: Realm!
    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        testRealm  = try! Realm()
        mockDataFetcher = MockAlbumDetailsFetcher()
        sut =   AlbumDetailsViewModel(dataFetcher: mockDataFetcher, album: mockDataFetcher.albumDetail, realm: testRealm)

    }
    override func tearDown() {
        super.tearDown()
        sut = nil
        mockDataFetcher = nil
        try! testRealm.write {
            testRealm.deleteAll()
        }
        
    }
    func testOutputAttributes() {
        XCTAssertEqual(sut.numberOfSections, 2)
        XCTAssertEqual(sut.title, mockDataFetcher.albumDetail.name)
    }
    func testNumberOfTracks() {
         XCTAssertEqual(sut.numberOfRows(of: 1), mockDataFetcher.albumDetail.tracks.count)
    }
    func testTrackModelForIndexPath() {
        let indexPath = IndexPath(row: 0, section: 1)
        let trackData = mockDataFetcher.albumDetail.tracks[indexPath.row]
        XCTAssertEqual(trackData, sut.getTrack(for: indexPath.row))
    }
    func testObjectAddedInDatabase() {
        sut.saveUnSaveAlbum { (isFav) in
            XCTAssertEqual(isFav, true)
            let Obj = try! Realm().object(ofType: Album.self, forPrimaryKey: mockDataFetcher.albumDetail.mbid)
            XCTAssertNotNil(Obj, "Object is not being save in database")
        }
    }
    func testObjectRemoveFromDatabase() {
        try! testRealm.write {
            mockDataFetcher.albumDetail.isFav = true
            testRealm.add(mockDataFetcher.albumDetail)
        }
        sut.saveUnSaveAlbum { (isFav) in
            XCTAssertEqual(isFav, false)
            let Obj = testRealm.object(ofType: Album.self, forPrimaryKey: mockDataFetcher.albumDetail.mbid)
            XCTAssertEqual(Obj?.isFav, false)
        }
        
    }

}
class MockAlbumDetailsFetcher: MusicaDataFetcherProtocol {
    var albumDetail:Album!
    init() {
        fetchNetworkData(method: EndPoint.albumDetails, queryParam: [:]) { (error:AppError?, album: Album?) in }
    }
    func fetchNetworkData<T>(method: EndPoint, queryParam: [String : Any], completion: @escaping (AppError?, T?) -> Void) where T : Decodable {
        let json: [String: Any] = ["name":"Cher",
                                   "mbid":"bfcc6d75",
                                   "image": [["#text":"https://lastfm-img2.akamaized.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png",
                                              "size":"small"]],
                                   "tracks":["track":[["name":"Believe",
                                                       "duration":"120"]]
            ]]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let albumData = try? JSONDecoder().decode(T.self, from: jsonData)
        albumDetail = albumData as? Album
        completion(nil, albumData)
    }
    
}
