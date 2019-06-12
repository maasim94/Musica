//
//  ArtistSearchViewControllerTests.swift
//  MusicaTests
//
//  Created by Arslan Asim on 12/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import XCTest
@testable import Musica

class ArtistSearchViewControllerTests: XCTestCase {

    var viewControllerUnderTest : ArtistSearchViewController!
    override func setUp() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: StorboardIDs.artistSearch) as? ArtistSearchViewController
        //load view hierarchy
        if(viewControllerUnderTest != nil) {
            viewControllerUnderTest.loadView()
            viewControllerUnderTest.viewDidLoad()
        }
    }

    override func tearDown() {
        viewControllerUnderTest = nil
    }
    //MARK:- tableview
    func testViewControllerIsComposeOfTableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView,"ViewController under test is not composed of a UITableView")
    }
    func testControllerConformsToTableViewDelegate() {
        XCTAssert(viewControllerUnderTest.conforms(to: UITableViewDelegate.self), "ViewController under test  does not conform to UITableViewDelegate protocol")
    }
    func testControllerConformsToTableViewDataSource() {
        XCTAssert(viewControllerUnderTest.conforms(to: UITableViewDataSource.self),"ViewController under test  does not conform to UITableViewDataSource protocol")
    }
    func testTableViewDelegateIsSet() {
        XCTAssertNotNil(self.viewControllerUnderTest.tableView.delegate)
    }
    func testTableViewDataSourceIsSet() {
        XCTAssertNotNil(self.viewControllerUnderTest.tableView.dataSource)
    }
    // MARK: - navigation
    func testSegues() {
        XCTAssert(viewControllerUnderTest.hasSegueWithIdentifier(id: Segues.artistSearchToAlbums) , "ViewController under test must have target segue of identifier \(Segues.artistSearchToAlbums)")
    }
}
