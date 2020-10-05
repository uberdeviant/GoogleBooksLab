//
//  BookExtendedInfoModel.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

class BookExtendedInfoModel: NSManagedObject {
    
    class func createModel(from bookVolumeInfo: BookVolumeInfo, context: NSManagedObjectContext) -> BookExtendedInfoModel {
        let model = BookExtendedInfoModel(context: context)
        model.title = bookVolumeInfo.title
        model.subtitle = bookVolumeInfo.subtitle
        model.publisher = bookVolumeInfo.publisher
        model.categories = bookVolumeInfo.categories
        model.authors = bookVolumeInfo.authors
        
        if let pageCount = bookVolumeInfo.pageCount {
            model.pageCount = pageCount
        } else {
            model.pageCount = 0
        }
        
        if let rating = bookVolumeInfo.averageRating {
            model.averageRaiting = rating
        } else {
            model.averageRaiting = 0
        }
        
        return model
    }
    
}
