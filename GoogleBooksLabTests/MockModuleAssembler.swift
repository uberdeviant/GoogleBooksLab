//
//  MockModuleAssembler.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockModuleAssembler: ModuleAssembling {
    func createShelfModule(router: Routerable) -> UIViewController {
        let networkService = MockNetworkService()
        let imageCache = MockImageCache()
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let view = ShelfCollectionViewController(collectionViewLayout: flowLayout)
        let presenter = ShelfPresenter(view: view, imageCache: imageCache, networkService: networkService, router: router)
        
        view.presenter = presenter
        
        return view
        
    }
    
    func createDetailModule(item: BookVolume?, router: Routerable) -> UIViewController {
        let networkService = MockNetworkService()
        let view = BookDetailViewController()
        let presenter = BookDetailPresenter(view: view, item: item, networkLayer: networkService, router: router)
        
        view.presenter = presenter
        
        return view
    }
}
