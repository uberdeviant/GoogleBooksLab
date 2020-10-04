//
//  FavouriteTableViewPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 04.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol FavouriteCellViewable: class {
    func updateCellBy(image: UIImage?, title: String)
}

protocol FavouriteCellPresentable {
    
    var bookID: String? {get set}
    
    init(view: FavouriteCellViewable, networkLayer: NetworkServicing, imageCache: ImageCachable, router: Routerable, bookModel: BookModel)
    
    func updateCellBy(model: BookModel)
    func prepareForReuse()
}

class FavouriteCellPresenter: FavouriteCellPresentable {
    
    weak var view: FavouriteCellViewable?
    var router: Routerable
    let networkLayer: NetworkServicing?
    let imageCache: ImageCachable?
    var bookID: String?
    
    var task: URLSessionDataTask?
    
    required init(view: FavouriteCellViewable, networkLayer: NetworkServicing, imageCache: ImageCachable, router: Routerable, bookModel: BookModel) {
        self.view = view
        self.networkLayer = networkLayer
        self.imageCache = imageCache
        self.router = router
        self.bookID = bookModel.volumeID
        
        updateCellBy(model: bookModel)
    }
    
    func prepareForReuse() {
        task?.cancel()// Task should be cancelled when reusing
    }
    
    func updateCellBy(model: BookModel) {
        let bookTitle = model.bookExtendedInfoModel?.title ?? "Unknown"
        
        guard let link = model.bookExtendedInfoModel?.imageLinksModel?.smallThumbnail,
            let imageURL = URL(string: link) else {
            view?.updateCellBy(image: nil, title: bookTitle)
            return
        }
        if let image = imageCache?.image(for: imageURL) {
            //If cache contains an image with the url, use it.
            view?.updateCellBy(image: image, title: bookTitle)
        } else {
            //If cache doesn't contains an image, load it from the web.
            task = networkLayer?.createLoadThumbnailTask(of: link, completion: {[weak self] (completion) in
                guard let self = self else {return}
                switch completion {
                case .success(let data):
                    //If everyrhing goes well, then save it into the cache and apply for the cell.
                    let image = UIImage(data: data)
                    self.imageCache?.insertImage(image, for: imageURL)
                    self.view?.updateCellBy(image: image, title: bookTitle)
                case .failure(_):
                    //If everyrhing has been failed, then update cell only by title.
                    self.view?.updateCellBy(image: nil, title: bookTitle)
                }
            })
            task?.resume()
        }
    }
}
