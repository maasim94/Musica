//
//  MusicaUITests.swift
//  MusicaUITests
//
//  Created by Arslan Asim on 09/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Musica

class MusicaUITests: XCTestCase {
    var app: XCUIApplication!
    var testRealm: Realm!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        testRealm  = try! Realm()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testAppFlow() {
        
        let isDisplayingSavedAlbums = app.otherElements["Stored Album View"].exists
        //first view exists
        XCTAssertTrue(isDisplayingSavedAlbums)
        let navigationbar = app.navigationBars["navigationBar"]
        XCTAssertTrue(navigationbar.exists)
        let searchButton = navigationbar.buttons["Search"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        // artist Searchview
        XCTAssertTrue(app.otherElements["search Artist View"].exists)
        let artistTable = app.tables["artistSearchTableView"]
        XCTAssertTrue(artistTable.exists)
        // search
        let keyboard = app.keyboards
        let keyboardKeys = keyboard.keys
        keyboardKeys["C"].tap()
        keyboardKeys["h"].tap()
        keyboardKeys["e"].tap()
        keyboardKeys["r"].tap()
        keyboard.buttons["Search"].tap()
        
        // wait for search to be completed
        let artistCell = artistTable.cells["artTableViewCell"]
        wait(element: artistCell, duration: 3.0)
        artistCell.firstMatch.tap()
        
        // album list view
        XCTAssertTrue(app.otherElements["albumListView"].exists)
        let albumListTable = app.tables["albumListTableView"]
        XCTAssertTrue(albumListTable.exists)
        let albumCell = albumListTable.cells["artTableViewCell"]
        wait(element: albumCell, duration: 3.0)
        albumCell.firstMatch.tap()
        
        // album details view
        XCTAssertTrue(app.otherElements["albumDetailsView"].exists)
        let albumDetailsTable = app.tables["albumDetailsTableView"]
        XCTAssertTrue(albumDetailsTable.exists)
        let albumDetailsCell = albumDetailsTable.cells["artTableViewCell"]
        wait(element: albumDetailsCell, duration: 3.0)
        
        let heartIcon = navigationbar.buttons["albumDetailsHeartIcon"]
        XCTAssertTrue(heartIcon.exists)
        
    }
    func wait(element: XCUIElement, duration: TimeInterval) {
        let predicate = NSPredicate(format: "exists == true")
        let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }

}
