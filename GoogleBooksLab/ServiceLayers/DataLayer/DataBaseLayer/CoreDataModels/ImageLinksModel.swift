//
//  ImageLinksModel.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 03.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import CoreData

class ImageLinksModel: NSManagedObject {
    
    class func createModel(from imageLinks: ImageLinks?, context: NSManagedObjectContext) -> ImageLinksModel? {
        guard let imageLinks = imageLinks else {return nil}
        let model = ImageLinksModel(context: context)
        model.thumbnail = imageLinks.thumbnail
        model.smallThumbnail = imageLinks.smallThumbnail
        model.small = imageLinks.small
        model.medium = imageLinks.medium
        model.large = imageLinks.large
        model.extraLarge = imageLinks.extraLarge
        
        return model
    }
    
}
