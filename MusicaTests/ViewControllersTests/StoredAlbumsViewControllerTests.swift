//
//  StoredAlbumsViewControllerTests.swift
//  MusicaTests
//
//  Created by Arslan Asim on 12/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import XCTest
@testable import Musica

class StoredAlbumsViewControllerTests: XCTestCase {

    var viewControllerUnderTest : StoredAlbumsViewController!
    override func setUp() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: StorboardIDs.mainPage) as? StoredAlbumsViewController
        //load view hierarchy
        if(viewControllerUnderTest != nil) {
            viewControllerUnderTest.loadView()
            viewControllerUnderTest.viewDidLoad()
        }
    }

    override func tearDown() {
        viewControllerUnderTest = nil
    }
    //MARK:- Collectionview
    func testViewControllerIsComposeOfCollectionView() {
        XCTAssertNotNil(viewControllerUnderTest.collectionView,"ViewController under test is not composed of a UICollectionView")
    }
    func testControllerConformsToCollectionViewDelegate() {
        XCTAssert(viewControllerUnderTest.conforms(to: UICollectionViewDelegate.self), "ViewController under test  does not conform to UICollectionViewDelegate protocol")
    }
    func testControllerConformsToCollectionViewDataSource() {
        XCTAssert(viewControllerUnderTest.conforms(to: UICollectionViewDataSource.self),"ViewController under test  does not conform to UICollectionViewDataSource protocol")
    }
    func testCollectionViewDelegateIsSet() {
        XCTAssertNotNil(self.viewControllerUnderTest.collectionView.delegate)
    }
    func testCollectionViewDataSourceIsSet() {
        XCTAssertNotNil(self.viewControllerUnderTest.collectionView.dataSource)
    }
    // MARK: - navigation
    func testSegues() {
        XCTAssertEqual(viewControllerUnderTest.numberOfSegues(), 2, "Segue count should equal two")
        XCTAssert(viewControllerUnderTest.hasSegueWithIdentifier(id: Segues.mainPageToDetails) , "ViewController under test must have target segue of identifier \(Segues.mainPageToDetails)")
        XCTAssert(viewControllerUnderTest.hasSegueWithIdentifier(id: Segues.mainPageToSearch) , "ViewController under test must have target segue of identifier \(Segues.mainPageToDetails)")
    }
    // MARK: -
    func testHasSearchBarButton() {
        let barButtonItem = viewControllerUnderTest.navigationItem.rightBarButtonItem
        let itemTypeRawValue = barButtonItem?.value(forKey: "systemItem") as! Int
        
        XCTAssertEqual(UIBarButtonItem.SystemItem(rawValue: itemTypeRawValue), UIBarButtonItem.SystemItem.search)
    }
}
