//
//  FavouriteTableViewPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 04.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol FavouriteCellPresentable {
    
    var bookID: String? {get set}
    
    init(view: PolyBookCellViewable, networkLayer: NetworkServicing, router: Routerable, bookModel: BookModel)
    
}

class FavouriteCellPresenter: PolyBookCellPresenter, FavouriteCellPresentable {
    
    var router: Routerable
    var bookID: String?
    
    required init(view: PolyBookCellViewable, networkLayer: NetworkServicing, router: Routerable, bookModel: BookModel) {
        self.router = router
        self.bookID = bookModel.volumeID
        
        super.init(view: view, networkLayer: networkLayer)
        
        super.needsToUpdateView(by: bookModel.bookExtendedInfoModel?.imageLinksModel?.smallThumbnail)
        super.needsToUpdateView(by: bookModel)
    }
    
}
