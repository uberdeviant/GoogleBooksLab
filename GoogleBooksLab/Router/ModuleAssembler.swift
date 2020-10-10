//
//  ModuleAssembler.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

protocol ModuleAssembling {
    func createShelfModule(router: Routerable) -> UIViewController
    func createDetailModule(item: BookObjectDescriptable?, router: Routerable) -> UIViewController
    func createFavouritesModule(router: Routerable) -> UIViewController
}

class ModuleAssembler: ModuleAssembling {
    func createShelfModule(router: Routerable) -> UIViewController {
        let imageCache = ImageDataCache() // Cache
        let networkService = NetworkService(cache: imageCache) // Create network Service
        let flowLayout = UICollectionViewFlowLayout() // Flow Layout
        flowLayout.scrollDirection = .vertical
        
        let view = ShelfCollectionViewController(collectionViewLayout: flowLayout) // Creste View
        let presenter = ShelfPresenter(view: view, networkService: networkService, router: router) // Create Presenter with injected View
        
        view.presenter = presenter // Inverse dependency
        
        return view
    }
    
    func createDetailModule(item: BookObjectDescriptable?, router: Routerable) -> UIViewController {
        let cache = ImageDataCache()
        let networkService = NetworkService(cache: cache) // Create network Service
        let view = BookDetailViewController() // Creste View
        let dataBasing = DataBaseLayer()
        let presenter = BookDetailPresenter(view: view, item: item, networkLayer: networkService, router: router, dataBasing: dataBasing) // Create Presenter with injected View
        
        view.presenter = presenter // Inverse dependency
        
        return view
    }
    
    func createFavouritesModule(router: Routerable) -> UIViewController {
        let view = FavouriteBooksTableViewController()
        let dataBasing = DataBaseLayer()
        let presenter = FavouriteBooksPresenter(view: view, dataBaseLayer: dataBasing, router: router)
        view.presenter = presenter
        
        return view
    }
    
}
