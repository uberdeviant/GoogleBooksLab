//
//  FavouritsBooksPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import CoreData

protocol FavouriteBooksViewable: class {
    func dataLoaded()
}

protocol FavouriteBooksPresentable {
    
    var favouriteBooks: [BookModel] {get set}
    
    init(view: FavouriteBooksViewable, persistantContainer: NSPersistentContainer?, dataBaseLayer: DataBasing, imageCache: ImageCachable, router: Routerable)
    
    func loadBooks()
    
    func rowSelected(at indexPath: IndexPath)
    
    func dequeueCell(tableView: AnyObject, indexPath: IndexPath, cellId: String) -> FavouriteTableViewCell?
}

class FavouriteBooksPresenter: FavouriteBooksPresentable {
    var persistantContainer: NSPersistentContainer?
    let dataBaseLayer: DataBasing
    var favouriteBooks: [BookModel] = []
    var imageCache: ImageCachable
    var router: Routerable?
    
    weak var view: FavouriteBooksViewable?
    
    required init(view: FavouriteBooksViewable, persistantContainer: NSPersistentContainer?, dataBaseLayer: DataBasing, imageCache: ImageCachable, router: Routerable) {
        self.persistantContainer = persistantContainer
        self.dataBaseLayer = dataBaseLayer
        self.imageCache = imageCache
        self.view = view
        self.router = router
    }
    
    func dequeueCell(tableView: AnyObject, indexPath: IndexPath, cellId: String) -> FavouriteTableViewCell? {
        let model = favouriteBooks[indexPath.row]
        return router?.dequeReusableFavouriteCell(for: tableView, indexPath: indexPath, cellId: cellId, model: model, imageCache: imageCache)
    }
    
    func loadBooks() {
        guard let context = persistantContainer?.viewContext else {return}
        favouriteBooks = dataBaseLayer.loadAllDataObjects(in: context)
        self.view?.dataLoaded()
    }
    
    func deleteBook(volumeID: String) {
        persistantContainer?.performBackgroundTask { [weak self] (context) in
            self?.dataBaseLayer.deleteBookModel(volumeId: volumeID, in: context)
            self?.view?.dataLoaded()
        }
    }
    
    func rowSelected(at indexPath: IndexPath) {
        
    }

}
