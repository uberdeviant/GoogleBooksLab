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
    
    init(view: FavouriteBooksViewable, persistantContainer: NSPersistentContainer, dataBaseLayer: DataBasing)
    
    func loadBooks()
}

class FavouritsBooksPresenter: FavouriteBooksPresentable {
    var persistantContainer: NSPersistentContainer
    let dataBaseLayer: DataBasing
    var favouriteBooks: [BookModel] = []
    weak var view: FavouriteBooksViewable?
    
    required init(view: FavouriteBooksViewable, persistantContainer: NSPersistentContainer, dataBaseLayer: DataBasing) {
        self.persistantContainer = persistantContainer
        self.dataBaseLayer = dataBaseLayer
        self.view = view
    }
    
    func loadBooks() {
        persistantContainer.performBackgroundTask { [weak self] (context) in
            self?.dataBaseLayer.loadAllDataObjects(in: context) { (results) in
                self?.favouriteBooks = results
                self?.view?.dataLoaded()
            }
        }
    }
    
    func deleteBook(volumeID: String) {
        persistantContainer.performBackgroundTask { [weak self] (context) in
            self?.dataBaseLayer.deleteBookModel(volumeId: volumeID, in: context)
            self?.view?.dataLoaded()
        }
    }

}
