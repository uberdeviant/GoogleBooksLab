//
//  Router.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

///The first router setting up appears in the SceneDelegate.
///It could be replaces into AppDelegate if it needs
///to support lower version of iOS.

protocol RouterContainable {
    var navigationController: UINavigationController? {get set}
    var moduleAssembler: ModuleAssembling? {get set}
}

protocol Routerable: RouterContainable {
    func instantiateShelfViewController()
}

class Router: Routerable {
    
    var navigationController: UINavigationController?
    var moduleAssembler: ModuleAssembling?
    
    init(navigationController: UINavigationController, moduleAssembler: ModuleAssembling) {
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }
    
    func instantiateShelfViewController() {
        guard let navigationController = navigationController,
        let shelfViewController = moduleAssembler?.createShelfModule(router: self) else {return}
        
        navigationController.viewControllers = [shelfViewController]
        
    }
    
}
