//
//  ShelfTests.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockShelfView: ShelfViewable {
    
    var success: Bool = false
    var error: Error?
    
    func searchResultsLoaded() {
        success = true
    }
    
    func falure(error: Error) {
        self.error = error
    }
}

class ShelfTests: XCTestCase {
    
    var view: MockShelfView!
    var router: Router!
    var navigationController: MockNavigationController!
    var presenter: ShelfPresentable!
    var imageCache: ImageCachable!

    override func setUpWithError() throws {
        navigationController = MockNavigationController()
        router = Router(navigationController: navigationController, moduleAssembler: ModuleAssembler())
        view = MockShelfView()
        imageCache = MockImageCache()
        presenter = ShelfPresenter(view: view, imageCache: imageCache, networkService: MockNetworkService(), router: router)
    }

    override func tearDownWithError() throws {
        router = nil
        presenter = nil
        view = nil
        imageCache = nil
        navigationController = nil
    }

    func testSuccesSearchResults() {
        presenter.performSearch(by: "foo")
        
        XCTAssertTrue(view.success)
        XCTAssertNil(view.error)
    }
    
    func testErrorResults() {
        presenter.performSearch(by: "error")
        
        XCTAssertFalse(view.success)
        XCTAssertNotNil(view.error)
    }
    
    func testCacheCleaning() {
        guard let url = URL(string: "foo") else { XCTFail("couldn't create a URL"); return }
        //Add image to Cache
        imageCache.insertImage(UIImage(), for: url)
        XCTAssertNotNil(imageCache.image(for: url))
        
        //Clear Cache
        presenter.clearCache()
        XCTAssertNil(imageCache.image(for: url))
    }
    
    func testGoToDetail() {
        presenter.performSearch(by: "foo")
        presenter.goToDetail(bookId: "bar")
        let presentedVC = navigationController.presentedVC
        
        XCTAssertTrue(presentedVC is BookDetailViewController)
    }
    
    func testFailGoToDetail() {
        presenter.performSearch(by: "error")
        presenter.goToDetail(bookId: "bar")
        let presentedVC = navigationController.presentedVC
        
        XCTAssertFalse(presentedVC is BookDetailViewController)
    }

}
