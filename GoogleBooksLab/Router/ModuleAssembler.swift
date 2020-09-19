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
}

class ModuleAssembler: ModuleAssembling {
    func createShelfModule(router: Routerable) -> UIViewController {
        let networkService = NetworkService() // Create network Service
        let view = ShelfViewController() // Creste View
        let presenter = ShelfPresenter(view: view, networkService: networkService, router: router) // Create Presenter with injected View
        
        view.presenter = presenter // Inverse dependency
        
        return view
    }
    
}
