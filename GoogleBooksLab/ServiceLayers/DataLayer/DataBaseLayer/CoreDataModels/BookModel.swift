//
//  BookModel.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

class BookModel: NSManagedObject {

    class func createModel(from bookVolume: BookVolume, context: NSManagedObjectContext) -> BookModel {
        let model = BookModel(context: context)
        model.volumeID = bookVolume.id
        model.selfLink = bookVolume.selfLink
        model.kind = bookVolume.kind
        
        return model
    }
    
}
