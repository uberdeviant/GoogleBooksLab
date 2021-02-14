//
//  FetchedDataBaseLayer.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 14.02.2021.
//  Copyright © 2021 Ramil Salimov. All rights reserved.
//

import CoreData

protocol FetchedDataBasing: DataBasing {
    var resultInfo: [NSFetchedResultsSectionInfo]? {get}
    
    func getObject(at indexPath: IndexPath) -> BookModel
    func performFetch()
    func setDelegate(delegate: NSFetchedResultsControllerDelegate)
}

class FetchedDataBase: DataBaseLayer, FetchedDataBasing {

    var resultInfo: [NSFetchedResultsSectionInfo]? { fetchedResultController.sections }
    
    lazy var fetchedResultController: NSFetchedResultsController<BookModel> = {
        let request: NSFetchRequest = BookModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(BookModel.kind), ascending: true)]

        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    func performFetch() {
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("FRC Core Data error", error)
        }
    }
    
    func getObject(at indexPath: IndexPath) -> BookModel {
        return fetchedResultController.object(at: indexPath)
    }
    
    func setDelegate(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultController.delegate = delegate
    }
}
