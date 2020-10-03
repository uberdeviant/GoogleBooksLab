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
    func createDetailModule(item: BookVolume?, router: Routerable) -> UIViewController
}

class ModuleAssembler: ModuleAssembling {
    func createShelfModule(router: Routerable) -> UIViewController {
        let networkService = NetworkService() // Create network Service
        let imageCache = ImageCache() // Cache
        let flowLayout = UICollectionViewFlowLayout() // Flow Layout
        flowLayout.scrollDirection = .vertical
        
        let view = ShelfCollectionViewController(collectionViewLayout: flowLayout) // Creste View
        let presenter = ShelfPresenter(view: view, imageCache: imageCache, networkService: networkService, router: router) // Create Presenter with injected View
        
        view.presenter = presenter // Inverse dependency
        
        return view
    }
    
    func createDetailModule(item: BookVolume?, router: Routerable) -> UIViewController {
        let networkService = NetworkService() // Create network Service
        let view = BookDetailViewController() // Creste View
        let persistantContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let dataBasing = DataBaseLayer()
        let presenter = BookDetailPresenter(view: view, item: item, networkLayer: networkService, router: router, persistentContainer: persistantContainer, dataBasing: dataBasing) // Create Presenter with injected View
        
        view.presenter = presenter // Inverse dependency
        
        return view
    }
    
}
