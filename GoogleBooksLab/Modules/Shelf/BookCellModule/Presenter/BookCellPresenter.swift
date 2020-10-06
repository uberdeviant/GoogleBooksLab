//
//  BookCellPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol BookCellPresentable {
    
    var bookID: String {get set}
    
    init(view: PolyBookCellViewable, networkLayer: NetworkServicing, imageCache: ImageCachable, router: Routerable, bookItem: BookVolume)
    
    func prepareForReuse()
}

class BookCellPresenter: PolyBookCellPresenter, BookCellPresentable {

    var router: Routerable
    var bookID: String
    
    required init(view: PolyBookCellViewable, networkLayer: NetworkServicing, imageCache: ImageCachable, router: Routerable, bookItem: BookVolume) {
        
        self.router = router
        self.bookID = bookItem.id
        
        super.init(view: view, imageCache: imageCache, networkLayer: networkLayer)
        
        super.needsToUpdateView(by: bookItem.volumeInfo.imageLinks?.smallThumbnail)
        super.needsToUpdateView(by: bookItem)
    }
    
    func prepareForReuse() {
        super.cancelImageTask()
    }
}
