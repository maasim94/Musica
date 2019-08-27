//
//  ArtistSearchViewModelTests.swift
//  MusicaTests
//
//  Created by Arslan Asim on 12/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import XCTest
@testable import Musica

class ArtistSearchViewModelTests: XCTestCase {

    var sut: ArtistSearchViewModel!
    var mockDataFetcher: MockMusicaDataFetcher!

    override func setUp() {
        mockDataFetcher = MockMusicaDataFetcher()
        sut = ArtistSearchViewModel(dataFetcher: mockDataFetcher)
        sut.getArtistForQuery(name: "", continuesProcess: false)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        mockDataFetcher = nil
    }
    func testOutputAttributes() {
        XCTAssertEqual(sut.numberOfRows , mockDataFetcher.artists.count)
    }
    func testDataModelForIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        let artistData = mockDataFetcher.artists[indexPath.row]
        XCTAssertEqual(artistData, sut.getArtist(for: indexPath.row))
    }
    func testDataModelForSelectionIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        let artistItem = mockDataFetcher.artists[indexPath.row]
        XCTAssertEqual(artistItem, sut.getArtist(for: indexPath.row))
    }

}
class MockMusicaDataFetcher: MusicaDataFetcherProtocol {
    var artists:[Artist] = []
    func fetchNetworkData<T>(method: EndPoint, queryParam: [String : Any], completion: @escaping (AppError?, T?) -> Void) where T : Decodable {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "artistJson", ofType: "json") else {
            return
        }
        let jsonString = try! String(contentsOfFile: path)
 
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let object = try!  decoder.decode(T.self, from: jsonData!)
        artists = (object as? ArtistRoot)?.artist ?? []
        completion(nil, object)
    }
    
}
