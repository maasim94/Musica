//
//  ArtistModelTests.swift
//  MusicaTests
//
//  Created by Arslan Asim on 12/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import XCTest
@testable import Musica
class ModelTests: XCTestCase {

    let testURLString = "https://lastfm-img2.akamaized.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    
    override func setUp() {
        continueAfterFailure = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testTrackAttributes() {
        let json = trackJson
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let trackData = try? JSONDecoder().decode(Track.self, from: jsonData)
        XCTAssertNotNil(trackData)
        XCTAssertEqual(trackData!.duration, "120")
        XCTAssertEqual(trackData!.name, "Believe")
    }
    func testArtistAttributes() {
        let json: [String: Any] = ["name":"Cher",
                                   "mbid":"bfcc6d75",
                                   "listeners":"2498755",
                                   "image": [imageJson]]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let artistData = try? JSONDecoder().decode(Artist.self, from: jsonData)
        
        
        XCTAssertNotNil(artistData)
        XCTAssertEqual(artistData!.name, "Cher")
        XCTAssertEqual(artistData!.mbid, "bfcc6d75")
        XCTAssertEqual(artistData!.getImageOf(size: .small)?.sizeString, "small")
        XCTAssertEqual(artistData!.getImageOf(size: .small)?.imageUrl, URL(string: testURLString))
    }
    func testAlbumAttributes() {
        let json: [String: Any] = ["name":"Cher",
                                   "mbid":"bfcc6d75",
                                   "playcount":"2498755",
                                   "image": [imageJson],
                                   "tracks":["track":[trackJson]
                                    ]]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let albumData = try? JSONDecoder().decode(Album.self, from: jsonData)
        
        XCTAssertNotNil(albumData)
        XCTAssertEqual(albumData!.name, "Cher")
        XCTAssertEqual(albumData!.mbid, "bfcc6d75")
        XCTAssertEqual(albumData!.tracks.count, 1)
        XCTAssertNotNil(albumData!.tracks.first)
        XCTAssertEqual(albumData!.tracks.first!.duration, "120")
        XCTAssertEqual(albumData!.tracks.first!.name, "Believe")
        XCTAssertEqual(albumData!.getImageOf(size: .small)?.sizeString, "small")
        XCTAssertEqual(albumData!.getImageOf(size: .small)?.imageUrl, URL(string: testURLString))
    }
    private var trackJson: [String:Any] {
        return ["name":"Believe",
                "duration":"120"]
    }
    private var imageJson: [String:Any] {
        return ["#text":testURLString,
                "size":"small"]
    }
}
