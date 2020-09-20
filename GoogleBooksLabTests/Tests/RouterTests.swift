//
//  RouterTests.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTests: XCTestCase {

    var router: Routerable!
    var navigationController = MockNavigationController()
    var assembler = MockModuleAssembler()
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, moduleAssembler: assembler)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testShelfInstantiating() {
        router.instantiateShelfViewController()
        let firstViewController = navigationController.viewControllers.first
        XCTAssertTrue(firstViewController is ShelfCollectionViewController)
    }
    
    func testBookDetailsInstantiating() {
        router.instantiateDetailViewController(by: nil)
        let detailViewController = navigationController.presentedVC
        XCTAssertTrue(detailViewController is BookDetailViewController)
    }
    
    func testCollectionView() {
        router.instantiateShelfViewController()
        guard let collectionViewController = navigationController.viewControllers.first as? ShelfCollectionViewController else {XCTFail("collectionView is not created"); return}
        
        collectionViewController.presenter?.performSearch(by: "foo")
        
        let firstItem = collectionViewController.presenter?.booksSearchResults?.items?[0]
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        let cell = router.dequeReusableBookCell(for: collectionViewController.collectionView, indexPath: indexPath, cellId: "bookCell", item: firstItem, imageCache: MockImageCache())
        
        XCTAssertNotNil(cell)
    }
    
    func testNilResultCollectionView() {
        router.instantiateShelfViewController()
        guard let collectionViewController = navigationController.viewControllers.first as? ShelfCollectionViewController else {XCTFail("collectionView is not created"); return}
        
        collectionViewController.presenter?.performSearch(by: "error")
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        let cell = router.dequeReusableBookCell(for: collectionViewController.collectionView, indexPath: indexPath, cellId: "bookCell", item: nil, imageCache: MockImageCache())
        
        XCTAssertNil(cell)
    }

}
