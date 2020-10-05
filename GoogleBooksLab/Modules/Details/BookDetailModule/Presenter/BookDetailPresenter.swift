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
    
    func updateLabels(by item: BookObjectDescriptable?)
    
    func favouritsUpdated(value: Bool)
}

protocol BookDetailPresentable: class {
    
    init(view: BookDetailViewable, item: BookObjectDescriptable?, networkLayer: NetworkServicing, router: Routerable, persistentContainer: NSPersistentContainer?, dataBasing: DataBasing)
    
    func loadImage()
    
    func updateLabels()
    
    func loadFavourite() 
    
    func heartTapped()
    
    func popToShelf()
    
}

class BookDetailPresenter: BookDetailPresentable {
    weak var view: BookDetailViewable?
    
    var persistentContainer: NSPersistentContainer?
    let dataBasing: DataBasing?
    let networkLayer: NetworkServicing?
    let router: Routerable?
    var item: BookObjectDescriptable?
    var isFavourite: Bool = false
    
    required init(view: BookDetailViewable, item: BookObjectDescriptable?, networkLayer: NetworkServicing, router: Routerable, persistentContainer: NSPersistentContainer?, dataBasing: DataBasing) {
        self.view = view
        self.networkLayer = networkLayer
        self.router = router
        self.item = item
        self.persistentContainer = persistentContainer
        self.dataBasing = dataBasing
    }
    
    func loadImage() {
        guard let link = item?.bookDescription.thumbnail else { return }
        
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
        guard let itemID = item?.bookDescription.volumeID else { return }
        persistentContainer?.performBackgroundTask({ [weak self] (context) in
            guard let self = self else {return}
            if self.dataBasing?.findBook(matching: itemID, in: context) != nil {
                self.isFavourite = true
            } else {
                self.isFavourite = false
            }
            self.view?.favouritsUpdated(value: self.isFavourite)
        })
    }
    
    func heartTapped() {
        guard let itemID = item?.bookDescription.volumeID else { return }
        persistentContainer?.performBackgroundTask({ [weak self] (context) in
            
            guard let self = self else {return}
            self.isFavourite = !self.isFavourite
            if self.isFavourite {
                guard let itemJSON = self.item as? BookVolume else {print("Manged Object is already deleted and couldn't be written again"); return}
                self.dataBasing?.writeBookModel(from: itemJSON, in: context)
            } else {
                self.dataBasing?.deleteBookModel(volumeId: itemID, in: context)
            }
            self.view?.favouritsUpdated(value: self.isFavourite)
        })
        
    }
    
    func popToShelf() {
        router?.popToRoot()
    }
    
}
