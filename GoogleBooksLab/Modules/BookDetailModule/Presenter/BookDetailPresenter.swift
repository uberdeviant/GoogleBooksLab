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
    
    func updateLabels(by item: BookObjectDescriptable?)
    
    func favouritesUpdated(value: Bool)
}

protocol BookDetailPresentable: class {
    
    init(view: BookDetailViewable, item: BookObjectDescriptable?, networkLayer: NetworkServicing, router: Routerable, dataBasing: DataBasing)
    
    func loadImage()
    
    func updateLabels()
    
    func loadFavourite() 
    
    func heartTapped()
    
    func popToShelf()
    
    func bindDataSaving()
}

class BookDetailPresenter: BookDetailPresentable {
    weak var view: BookDetailViewable?
    
    var dataBasing: DataBasing?
    let networkLayer: NetworkServicing?
    let router: Routerable?
    var item: BookObjectDescriptable?
    var isFavourite: Bool = false
    
    required init(view: BookDetailViewable, item: BookObjectDescriptable?, networkLayer: NetworkServicing, router: Routerable, dataBasing: DataBasing) {
        self.view = view
        self.networkLayer = networkLayer
        self.router = router
        self.item = item
        self.dataBasing = dataBasing
    }
    
    func heartTapped() {
        guard let itemID = item?.bookDescription.volumeID else { return }
        self.isFavourite = !self.isFavourite
        if self.isFavourite {
            guard let itemJSON = self.item as? BookVolume else {print("Manged Object is already deleted and couldn't be written again"); return}
            // When a user taps a heart button, saving performs in the background thread
            self.dataBasing?.writeBookModel(from: itemJSON)
        } else {
            self.dataBasing?.deleteBookModel(volumeId: itemID)
            self.view?.favouritesUpdated(value: self.isFavourite)
        }
    }
    
    func bindDataSaving() {
        // Then we listen to objectSaved closure, return NSManagedObjectID of saved object and try to find in the Main thread
        dataBasing?.objectSaved = {[weak self] (objectID) in
            guard let id = objectID else {return}
            DispatchQueue.main.async {
                self?.dataBasing?.findBy(objectID: id)
            }
        }
        // When the object found we updateUI
        dataBasing?.objectFound = {[weak self] (value) in
            self?.view?.favouritesUpdated(value: value)
        }
    }
    
    func loadImage() {
        guard let link = item?.bookDescription.thumbnail else { return }
        
        networkLayer?.loadThumbnail(of: link, completion: { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.view?.imageLoaded(imageData: data)
            case .failure(let error):
                self.view?.imageLoadFailure(error: error)
            }
        })
    }
    
    func updateLabels() {
        self.view?.updateLabels(by: item)
    }
    
    func loadFavourite() {
        guard let itemID = item?.bookDescription.volumeID else { return }
        if self.dataBasing?.findBook(matching: itemID) != nil {
            self.isFavourite = true
        } else {
            self.isFavourite = false
        }
        self.view?.favouritesUpdated(value: self.isFavourite)
    }
    
    func popToShelf() {
        router?.popToRoot()
    }
    
}
