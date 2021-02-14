//
//  FavouritsBooksPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import CoreData.NSFetchedResultsController

protocol FavouriteBooksViewable: class {
    func dataLoaded()
    func objectDeleted(at indexPath: IndexPath)
}

protocol FavouriteBooksPresentable: class {
    
    var resultInfo: [NSFetchedResultsSectionInfo]? { get }
    
    init(view: FavouriteBooksViewable, dataBaseLayer: FetchedDataBasing, router: Routerable)
    
    func setDelegate()
    
    func loadBooks()
    
    func rowSelected(at indexPath: IndexPath)
    
    func deleteBook(at indexPath: IndexPath) 
    
    func dequeueCell(tableView: AnyObject, indexPath: IndexPath, cellId: String) -> FavouriteTableViewCell?
}

class FavouriteBooksPresenter: NSObject, FavouriteBooksPresentable {
    let dataBaseLayer: FetchedDataBasing
    var resultInfo: [NSFetchedResultsSectionInfo]? { dataBaseLayer.resultInfo }
    var router: Routerable?
    
    weak var view: FavouriteBooksViewable?
    
    required init(view: FavouriteBooksViewable, dataBaseLayer: FetchedDataBasing, router: Routerable) {
        self.dataBaseLayer = dataBaseLayer
        self.view = view
        self.router = router
    }
    
    func setDelegate() {
        self.dataBaseLayer.setDelegate(delegate: self)
    }
    
    func dequeueCell(tableView: AnyObject, indexPath: IndexPath, cellId: String) -> FavouriteTableViewCell? {
        let model = dataBaseLayer.getObject(at: indexPath)
        return router?.dequeReusableFavouriteCell(for: tableView, indexPath: indexPath, cellId: cellId, model: model)
    }
    
    func loadBooks() {
        dataBaseLayer.performFetch()
    }
    
    func deleteBook(at indexPath: IndexPath) {
        guard let volumeID = dataBaseLayer.getObject(at: indexPath).volumeID else {return}
        dataBaseLayer.deleteBookModel(volumeId: volumeID)
    }
    
    func rowSelected(at indexPath: IndexPath) {
        router?.instantiateDetailViewController(by: dataBaseLayer.getObject(at: indexPath), needsToPush: false)
    }

}

extension FavouriteBooksPresenter: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .delete:
            view?.objectDeleted(at: indexPath)
        default:
            break
        }
    }
}
