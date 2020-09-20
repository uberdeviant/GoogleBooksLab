//
//  DetailTests.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockDetailView: BookDetailViewable {
    
    var loadedImageData: Bool = false
    var itemTitle: String?
    var error: Error?
    
    func imageLoaded(imageData: Data) {
        loadedImageData = true
        error = nil
    }
    
    func imageLoadFailure(error: Error) {
        loadedImageData = false
        self.error = error
    }
    
    func updateLabels(by item: BookVolume?) {
        itemTitle = item?.volumeInfo.title
    }
}

class DetailTests: XCTestCase {
    
    var view: MockDetailView!
    var router: Router!
    var networkService: MockNetworkService!
    var navigationController: MockNavigationController!
    var presenter: BookDetailPresenter!
    var bookItem: BookVolume!
    
    override func setUpWithError() throws {
        navigationController = MockNavigationController()
        router = Router(navigationController: navigationController, moduleAssembler: ModuleAssembler())
        networkService = MockNetworkService()
        view = MockDetailView()
        bookItem = networkService.returnMockSearchResultBooks().items?.first
        presenter = BookDetailPresenter(view: view, item: bookItem, networkLayer: networkService, router: router)
    }

    override func tearDownWithError() throws {
        router = nil
        presenter = nil
        view = nil
        networkService = nil
        navigationController = nil
        bookItem = nil
    }

    func testSuccessImageLoad() {
        presenter.loadImage()
        
        XCTAssertTrue(view.loadedImageData)
        XCTAssertNil(view.error)
    }
    
    func testFailImageLoad() {
        networkService.successThumbnail = false
        
        presenter.loadImage()
        
        XCTAssertFalse(view.loadedImageData)
        XCTAssertNotNil(view.error)
    }
    
    func testSuccessUpdateLabels() {
        presenter.updateLabels()
        
        XCTAssertNotNil(view.itemTitle)
    }
    
    func testFailUpdateLabels() {
        presenter.item = nil
        presenter.updateLabels()
        
        XCTAssertNil(view.itemTitle)
    }
    
    func testPopToShelf() {
        presenter.popToShelf()
        let presentedVC = navigationController.presentedVC
        
        XCTAssertFalse(presentedVC is BookDetailViewController)
    }

}
