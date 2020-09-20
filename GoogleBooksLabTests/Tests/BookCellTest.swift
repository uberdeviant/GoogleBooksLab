//
//  BookCellTest.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockBookCellView: BookCellViewable {
    var hasTitle: Bool = false
    var hasImage: Bool = false
    
    func updateCellBy(image: UIImage?, title: String) {
        if image != nil {
            hasImage = true
        }
        
        hasTitle = true
    }
}

class BookCellTest: XCTestCase {
    var router: Router!
    var view: MockBookCellView!
    var presenter: BookCellPresenter!
    var imageCache: ImageCachable!
    var bookItem: BookVolume!
    var networkLayer: MockNetworkService!

    override func setUpWithError() throws {
        router = Router(navigationController: MockNavigationController(), moduleAssembler: ModuleAssembler())
        view = MockBookCellView()
        imageCache = MockImageCache()
        networkLayer = MockNetworkService()
        bookItem = networkLayer.returnMockSearchResultBooks().items?.first
        
        presenter = BookCellPresenter(view: view, networkLayer: networkLayer, imageCache: imageCache, router: router, bookItem: bookItem)
    }

    override func tearDownWithError() throws {
        router = nil
        presenter = nil
        view = nil
        imageCache = nil
        networkLayer = nil
        bookItem = nil
    }

    func testUpdateCellTitle() {
        presenter.updateCellBy(item: bookItem)
        
        XCTAssertTrue(view.hasTitle)
    }
    
    func testUpdateCellByCache() {
        let smallThumbnail = bookItem.volumeInfo.imageLinks!.smallThumbnail
        
        imageCache.insertImage(UIImage(), for: URL(string: smallThumbnail)!)
        
        presenter.updateCellBy(item: bookItem)
        
        XCTAssertTrue(view.hasImage)
        
        imageCache.removeAllImages()
    }
    
    func testFailLinkImage() {
        bookItem = networkLayer.returnMockSearchResultBooks(loadImages: false).items?.first
        
        presenter.updateCellBy(item: bookItem)
        XCTAssertFalse(view.hasImage) // Shouldn't has an image
        XCTAssertTrue(view.hasTitle) // Shouldn has a title
    }
    
    func testImageLoading() {
        
        presenter.updateCellBy(item: bookItem)
        XCTAssertFalse(view.hasImage)
        
    }
    
    func testPrepareForReuse() {
        presenter.updateCellBy(item: bookItem)
        
        presenter.prepareForReuse()
        
        XCTAssertTrue(presenter.task?.state == URLSessionTask.State.canceling)
    }

}
