//
//  FavouritsBooksPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol FavouriteBooksViewable: class {
    func dataLoaded()
    func objectDeleted(at indexPath: IndexPath)
}

protocol FavouriteBooksPresentable: class {
    
    var favouriteBooks: [BookModel] {get set}
    
    init(view: FavouriteBooksViewable, dataBaseLayer: DataBasing, router: Routerable)
    
    func loadBooks()
    
    func rowSelected(at indexPath: IndexPath)
    
    func deleteBook(at indexPath: IndexPath) 
    
    func dequeueCell(tableView: AnyObject, indexPath: IndexPath, cellId: String) -> FavouriteTableViewCell?
}

class FavouriteBooksPresenter: FavouriteBooksPresentable {
    let dataBaseLayer: DataBasing
    var favouriteBooks: [BookModel] = []
    var router: Routerable?
    
    weak var view: FavouriteBooksViewable?
    
    required init(view: FavouriteBooksViewable, dataBaseLayer: DataBasing, router: Routerable) {
        self.dataBaseLayer = dataBaseLayer
        self.view = view
        self.router = router
    }
    
    func dequeueCell(tableView: AnyObject, indexPath: IndexPath, cellId: String) -> FavouriteTableViewCell? {
        let model = favouriteBooks[indexPath.row]
        return router?.dequeReusableFavouriteCell(for: tableView, indexPath: indexPath, cellId: cellId, model: model)
    }
    
    func loadBooks() {
        favouriteBooks = dataBaseLayer.loadAllDataObjects()
        self.view?.dataLoaded()
    }
    
    func deleteBook(at indexPath: IndexPath) {
        guard let volumeID = favouriteBooks[indexPath.row].volumeID else {return}
        dataBaseLayer.deleteBookModel(volumeId: volumeID)
        favouriteBooks.remove(at: indexPath.row)
        view?.objectDeleted(at: indexPath)
    }
    
    func rowSelected(at indexPath: IndexPath) {
        router?.instantiateDetailViewController(by: favouriteBooks[indexPath.row], needsToPush: false)
    }

}
