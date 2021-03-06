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
    func dequeReusableBookCell(for collectionView: AnyObject, indexPath: IndexPath, cellId: String, item: BookVolume?) -> BookCollectionViewCell?
    func dequeReusableFavouriteCell(for tableView: AnyObject, indexPath: IndexPath, cellId: String, model: BookModel?) -> FavouriteTableViewCell?
    func instantiateDetailViewController(by item: BookObjectDescriptable?, needsToPush: Bool)
    func instantiateFavouriteBooks()
    func popToRoot()
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
    
    func dequeReusableBookCell(for collectionView: AnyObject, indexPath: IndexPath, cellId: String, item: BookVolume?) -> BookCollectionViewCell? {
        //We need to use AnyObject because we don't want to import UIKit for presenter
        guard let collectionView = collectionView as? UICollectionView, let item = item else {return nil}
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BookCollectionViewCell else {return nil}
        let networkService = NetworkService(cache: ImageDataCache())
        let presenter = BookCellPresenter(view: cell, networkLayer: networkService, router: self, bookItem: item)
        cell.presenter = presenter
        
        return cell
        
    }
    
    func dequeReusableFavouriteCell(for tableView: AnyObject, indexPath: IndexPath, cellId: String, model: BookModel?) -> FavouriteTableViewCell? {
        //We need to use AnyObject because we don't want to import UIKit for presenter
        guard let tableView = tableView as? UITableView, let model = model else {return nil}
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FavouriteTableViewCell else {return nil}
        let networkService = NetworkService(cache: ImageDataCache())
        let presenter = FavouriteCellPresenter(view: cell, networkLayer: networkService, router: self, bookModel: model)
        cell.presenter = presenter
        
        return cell
        
    }
    
    func instantiateDetailViewController(by item: BookObjectDescriptable?, needsToPush: Bool) {
        guard let navigationController = navigationController,
        let detailViewController = moduleAssembler?.createDetailModule(item: item, router: self) else {return}
        
        if needsToPush {
            navigationController.pushViewController(detailViewController, animated: true)
        } else {
            navigationController.presentedViewController?.present(detailViewController, animated: true, completion: nil)
        }
    }
    
    func instantiateFavouriteBooks() {
        guard let navigationController = navigationController,
              let favouritesTableViewController = moduleAssembler?.createFavouritesModule(router: self) else {return}
        navigationController.present(favouritesTableViewController, animated: true, completion: nil)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
