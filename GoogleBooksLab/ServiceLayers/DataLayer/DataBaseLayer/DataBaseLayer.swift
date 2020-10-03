//
//  DataBaseLayer.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

protocol DataBasing {
    func findBook(matching bookVolumeID: String, in context: NSManagedObjectContext) -> BookModel?
    
    func writeBookModel(from bookVolume: BookVolume, in context: NSManagedObjectContext)
    
    func deleteBookModel(volumeId: String, in context: NSManagedObjectContext)
    
    func loadAllDataObjects(in context: NSManagedObjectContext, completion: @escaping([BookModel]) -> Void)
}

class DataBaseLayer: DataBasing {
    
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
    
    func writeBookModel(from bookVolume: BookVolume, in context: NSManagedObjectContext) {
        if let book = findBook(matching: bookVolume.id, in: context) {
            context.delete(book)
        }
        
        let book = BookModel.createModel(from: bookVolume, context: context)
        let extendedBook = BookExtendedInfoModel.createModel(from: bookVolume.volumeInfo, context: context)
        let imageLinks = ImageLinksModel.createModel(from: bookVolume.volumeInfo.imageLinks, context: context)
        
        //Relations
        book.bookExtendedInfoModel = extendedBook
        extendedBook.bookModel = book
        extendedBook.imageLinksModel = imageLinks
        imageLinks?.bookExtendedInfoModel = extendedBook
        
        try? context.save()
            
    }
    
    func deleteBookModel(volumeId: String, in context: NSManagedObjectContext) {
        if let book = findBook(matching: volumeId, in: context) {
            context.delete(book)
            try? context.save()
        }
        
    }
    
    func loadAllDataObjects(in context: NSManagedObjectContext, completion: @escaping([BookModel]) -> Void) {
        context.perform {
            let request: NSFetchRequest<BookModel> = BookModel.fetchRequest()
            do {
                let objects = try? context.fetch(request)
                if objects != nil {
                    completion(objects!)
                } else {
                    completion([])
                }
            }
        }
    }
}
