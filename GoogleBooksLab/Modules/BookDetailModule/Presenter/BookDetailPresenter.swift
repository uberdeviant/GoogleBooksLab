//
//  BookDetailPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol BookDetailViewable: class {
    func imageLoaded(imageData: Data)
    
    func imageLoadFailure(error: Error)
    
    func updateLabels(by item: BookVolume)
}

protocol BookDetailPresentable: class {
    
    init(view: BookDetailViewable, item: BookVolume, networkLayer: NetworkServicing, router: Routerable)
    
    func loadImage()
    
    func updateLabels()
    
    func popToShelf()
}

class BookDetailPresenter: BookDetailPresentable {
    weak var view: BookDetailViewable?
    let networkLayer: NetworkServicing?
    let router: Routerable?
    var item: BookVolume
    
    required init(view: BookDetailViewable, item: BookVolume, networkLayer: NetworkServicing, router: Routerable) {
        self.view = view
        self.networkLayer = networkLayer
        self.router = router
        self.item = item
    }
    
    func loadImage() {
        guard let link = item.volumeInfo.imageLinks?.thumbnail,
            let url = URL(string: link) else {return}
        self.networkLayer?.loadThumbnail(of: url, completion: {[weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.view?.imageLoaded(imageData: data)
            case .failure(let error):
                self.view?.imageLoadFailure(error: error)
            }
        }).resume()
    }
    
    func updateLabels() {
        self.view?.updateLabels(by: item)
    }
    
    func popToShelf() {
        router?.popToRoot()
    }
    
}
