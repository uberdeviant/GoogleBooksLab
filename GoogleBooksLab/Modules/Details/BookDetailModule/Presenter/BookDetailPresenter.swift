//
//  BookDetailPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import CoreData

protocol BookDetailViewable: class {
    func imageLoaded(imageData: Data)
    
    func imageLoadFailure(error: Error)
    
    func updateLabels(by item: BookVolume?)
    
    func favouritsUpdated(value: Bool)
}

protocol BookDetailPresentable: class {
    
    init(view: BookDetailViewable, item: BookVolume?, networkLayer: NetworkServicing, router: Routerable, persistentContainer: NSPersistentContainer?, dataBasing: DataBasing)
    
    func loadImage()
    
    func updateLabels()
    
    func loadFavourite() 
    
    func heartTapped()
    
    func popToShelf()
    
}

class BookDetailPresenter: BookDetailPresentable {
    weak var view: BookDetailViewable?
    
    var persistentContainer: NSPersistentContainer?
    var bookModel: BookModel?
    let dataBasing: DataBasing?
    let networkLayer: NetworkServicing?
    let router: Routerable?
    var item: BookVolume?
    var isFavourite: Bool = false
    
    required init(view: BookDetailViewable, item: BookVolume?, networkLayer: NetworkServicing, router: Routerable, persistentContainer: NSPersistentContainer?, dataBasing: DataBasing) {
        self.view = view
        self.networkLayer = networkLayer
        self.router = router
        self.item = item
        self.persistentContainer = persistentContainer
        self.dataBasing = dataBasing
    }
    
    func loadImage() {
        guard let link = item?.volumeInfo.imageLinks?.thumbnail else { return }
        
        let task = self.networkLayer?.createLoadThumbnailTask(of: link, completion: {[weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.view?.imageLoaded(imageData: data)
            case .failure(let error):
                self.view?.imageLoadFailure(error: error)
            }
        })
        
        task?.resume()
    }
    
    func updateLabels() {
        self.view?.updateLabels(by: item)
    }
    
    func loadFavourite() {
        guard let item = item else { return }
        persistentContainer?.performBackgroundTask({ [weak self] (context) in
            guard let self = self else {return}
            if self.dataBasing?.findBook(matching: item.id, in: context) != nil {
                self.isFavourite = true
            } else {
                self.isFavourite = false
            }
            self.view?.favouritsUpdated(value: self.isFavourite)
        })
    }
    
    func heartTapped() {
        guard let item = item else { return }
        persistentContainer?.performBackgroundTask({ [weak self] (context) in
            
            guard let self = self else {return}
            self.isFavourite = !self.isFavourite
            if self.isFavourite {
                self.dataBasing?.writeBookModel(from: item, in: context)
            } else {
                self.dataBasing?.deleteBookModel(volumeId: item.id, in: context)
            }
            self.view?.favouritsUpdated(value: self.isFavourite)
        })
        
    }
    
    func popToShelf() {
        router?.popToRoot()
    }
    
}
