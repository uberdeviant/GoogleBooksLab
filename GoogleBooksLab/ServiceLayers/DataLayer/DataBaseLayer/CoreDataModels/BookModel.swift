//
//  BookModel.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

class BookModel: NSManagedObject, BookObjectDescriptable {

    var bookDescription: BookObjectDescription {
        return (volumeID: volumeID,
                title: bookExtendedInfoModel?.title,
                authors: bookExtendedInfoModel?.authors,
                categories: bookExtendedInfoModel?.categories,
                publisher: bookExtendedInfoModel?.publisher,
                pageCount: bookExtendedInfoModel?.pageCount,
                rating: bookExtendedInfoModel?.averageRaiting,
                smallThumbnail: bookExtendedInfoModel?.imageLinksModel?.smallThumbnail,
                thumbnail: bookExtendedInfoModel?.imageLinksModel?.thumbnail)
    }
    
    class func createModel(from bookVolume: BookVolume, context: NSManagedObjectContext) -> BookModel {
        let model = BookModel(context: context)
        model.volumeID = bookVolume.id
        model.selfLink = bookVolume.selfLink
        model.kind = bookVolume.kind
        
        return model
    }
    
}
