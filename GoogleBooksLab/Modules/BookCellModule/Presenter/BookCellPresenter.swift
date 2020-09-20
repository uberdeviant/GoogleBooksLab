//
//  BookCellPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol BookCellViewable: class {
    func updateCellBy(image: UIImage?, title: String)
}

protocol BookCellPresentable {
    
    var bookID: String {get set}
    
    init(view: BookCellViewable, networkLayer: NetworkServicing, imageCache: ImageCachable, router: Routerable, bookItem: BookVolume)
    
    func updateCellBy(item: BookVolume)
    func prepareForReuse()
}

class BookCellPresenter: BookCellPresentable {
    
    weak var view: BookCellViewable?
    var router: Routerable
    let networkLayer: NetworkServicing?
    let imageCache: ImageCachable?
    var bookID: String
    
    var task: URLSessionDataTask?
    
    required init(view: BookCellViewable, networkLayer: NetworkServicing, imageCache: ImageCachable, router: Routerable, bookItem: BookVolume) {
        self.view = view
        self.networkLayer = networkLayer
        self.imageCache = imageCache
        self.router = router
        self.bookID = bookItem.id
        
        updateCellBy(item: bookItem)
    }
    
    func prepareForReuse() {
        task?.cancel()// Task should be cancelled when reusing
    }
    
    func updateCellBy(item: BookVolume) {
        guard let link = item.volumeInfo.imageLinks?.smallThumbnail,
            let imageURL = URL(string: link) else {
            view?.updateCellBy(image: nil, title: item.volumeInfo.title)
            return
        }
        if let image = imageCache?.image(for: imageURL) {
            //If cache contains an image with the url, use it.
            view?.updateCellBy(image: image, title: item.volumeInfo.title)
        } else {
            //If cache doesn't contains an image, load it from the web.
            task = networkLayer?.loadThumbnail(of: imageURL, completion: {[weak self] (completion) in
                guard let self = self else {return}
                switch completion {
                case .success(let data):
                    //If everyrhing goes well, then save it into the cache and apply for the cell.
                    let image = UIImage(data: data)
                    self.imageCache?.insertImage(image, for: imageURL)
                    self.view?.updateCellBy(image: image, title: item.volumeInfo.title)
                case .failure(_):
                    //If everyrhing has been failed, then update cell only by title.
                    self.view?.updateCellBy(image: nil, title: item.volumeInfo.title)
                }
            })
            task?.resume()
        }
    }
}
