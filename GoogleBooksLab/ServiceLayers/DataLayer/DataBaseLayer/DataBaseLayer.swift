//
//  DataBaseLayer.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

protocol DataBasing {
    func findBook(matching bookVolumeID: String) -> BookModel?
    
    func writeBookModel(from bookVolume: BookVolume)
    
    func deleteBookModel(volumeId: String)
    
    func loadAllDataObjects() -> [BookModel]
}

class DataBaseLayer: DataBasing {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoogleBooksLab")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func findBook(matching bookVolumeID: String) -> BookModel? {
        let request: NSFetchRequest<BookModel> = BookModel.fetchRequest()
        request.predicate = NSPredicate(format: "volumeID = %@", bookVolumeID)
        
        let matches = try? viewContext.fetch(request)
        if let unwMatches = matches, !unwMatches.isEmpty {
            return unwMatches[0]
        } else {
            return nil
        }
    }
    
    func writeBookModel(from bookVolume: BookVolume) {
        if let book = findBook(matching: bookVolume.id) {
            viewContext.delete(book)
        }
        
        let book = BookModel.createModel(from: bookVolume, context: viewContext)
        let extendedBook = BookExtendedInfoModel.createModel(from: bookVolume.volumeInfo, context: viewContext)
        let imageLinks = ImageLinksModel.createModel(from: bookVolume.volumeInfo.imageLinks, context: viewContext)
        
        //Relations
        extendedBook.imageLinksModel = imageLinks
        book.bookExtendedInfoModel = extendedBook
        
        try? viewContext.save()
    }
    
    func deleteBookModel(volumeId: String) {
        if let book = findBook(matching: volumeId) {
            viewContext.delete(book)
            try? viewContext.save()
        }
        
    }
    
    func loadAllDataObjects() -> [BookModel] {
            
        let request: NSFetchRequest<BookModel> = BookModel.fetchRequest()
        
        do {
            let objects = try viewContext.fetch(request)
            return objects
        } catch {
            print(error.localizedDescription)
            return []
        }
        
    }
}
