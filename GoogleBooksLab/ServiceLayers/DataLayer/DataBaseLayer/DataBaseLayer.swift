//
//  DataBaseLayer.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

protocol DataBasing {
    var objectSaved: ((NSManagedObjectID?) -> Void)? {get set}
    var objectFound: ((Bool) -> Void)? {get set}

    func findBook(matching bookVolumeID: String, in context: NSManagedObjectContext) -> BookModel?
    func findBy(objectID: NSManagedObjectID)
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
    
    var objectSaved: ((NSManagedObjectID?) -> Void)?
    var objectFound: ((Bool) -> Void)?
    
    func findBook(matching bookVolumeID: String, in context: NSManagedObjectContext) -> BookModel? {
        let request: NSFetchRequest<BookModel> = BookModel.fetchRequest()
        request.predicate = NSPredicate(format: "volumeID = %@", bookVolumeID)
        
        let matches = try? context.fetch(request)
        if let unwMatches = matches, !unwMatches.isEmpty {
            return unwMatches[0]
        } else {
            return nil
        }
    }
    
    func writeBookModel(from bookVolume: BookVolume) {
        persistentContainer.performBackgroundTask { [weak self] (context) in
            guard let self = self else {return}
            if let book = self.findBook(matching: bookVolume.id, in: context) {
                context.delete(book)
            }
            
            let book = BookModel.createModel(from: bookVolume, context: context)
            let extendedBook = BookExtendedInfoModel.createModel(from: bookVolume.volumeInfo, context: context)
            let imageLinks = ImageLinksModel.createModel(from: bookVolume.volumeInfo.imageLinks, context: context)
            
            //Relations
            extendedBook.imageLinksModel = imageLinks
            book.bookExtendedInfoModel = extendedBook
            
            do {
                try context.save()
                print("Saving - Current Thread:", Thread.current)
                self.objectSaved?(book.objectID)
            } catch {
                self.objectSaved?(nil)
            }
        }
    }
    
    func findBy(objectID: NSManagedObjectID) {
        do {
            let object = try viewContext.existingObject(with: objectID) // return a fault
            print("Loading - Current Thread:", Thread.current)
            print("Passed ID and object ID are equal: \(objectID == object.objectID)")
            objectFound?(true)
        } catch {
            objectFound?(false)
        }
    }
    
    func deleteBookModel(volumeId: String) {
        if let book = findBook(matching: volumeId, in: viewContext) {
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
