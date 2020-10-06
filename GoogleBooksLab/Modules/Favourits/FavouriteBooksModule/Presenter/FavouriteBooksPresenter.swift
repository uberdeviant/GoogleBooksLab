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
    func objectDeleted(at indexPath: IndexPath)
}

protocol FavouriteBooksPresentable: class {
    
    var favouriteBooks: [BookModel] {get set}
    
    init(view: FavouriteBooksViewable, persistantContainer: NSPersistentContainer?, dataBaseLayer: DataBasing, imageCache: ImageCachable, router: Routerable)
    
    func loadBooks()
    
    func rowSelected(at indexPath: IndexPath)
    
    func deleteBook(at indexPath: IndexPath) 
    
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
    
    func deleteBook(at indexPath: IndexPath) {
        guard let volumeID = favouriteBooks[indexPath.row].volumeID else {return}
        persistantContainer?.performBackgroundTask { [weak self] (context) in
            self?.dataBaseLayer.deleteBookModel(volumeId: volumeID, in: context)
            self?.favouriteBooks.remove(at: indexPath.row)
            self?.view?.objectDeleted(at: indexPath)
        }
    }
    
    func rowSelected(at indexPath: IndexPath) {
        router?.instantiateDetailViewController(by: favouriteBooks[indexPath.row], needsToPush: false)
    }

}
