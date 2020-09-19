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
    func dequeReusableBookCell(for collectionView: AnyObject, indexPath: IndexPath, cellId: String, item: BookVolume, imageCache: ImageCache) -> AnyObject
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
    
    func dequeReusableBookCell(for collectionView: AnyObject, indexPath: IndexPath, cellId: String, item: BookVolume, imageCache: ImageCache) -> AnyObject {
        //We need to use AnyObject because we don't want to import UIKit to presenter
        guard let collectionView = collectionView as? UICollectionView else {return UICollectionViewCell()}
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BookCollectionViewCell else {return UICollectionViewCell()}
        let presenter = BookCellPresenter(view: cell, networkLayer: NetworkService(), imageCache: imageCache, router: self, bookItem: item)
        cell.presenter = presenter
        
        return cell
        
    }
    
}
