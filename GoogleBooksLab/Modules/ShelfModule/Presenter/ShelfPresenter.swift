//
//  ShelfPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol ShelfViewable: class {
    func searchResultsLoaded()
    func falure(error: Error)
}

protocol ShelfPresentable: class {
    
    var booksSearchResults: BookSearchResult? {get set}
    
    init(view: ShelfViewable, networkService: NetworkServicing, router: Routerable)
    
    // MARK: - Network
    
    func performSearch(by text: String)
    
    // MARK: - Navigation
    
    func dequeueCell(collectionView: AnyObject, indexPath: IndexPath, cellId: String) -> AnyObject?
}

class ShelfPresenter: ShelfPresentable {
    
    weak var view: ShelfViewable?
    var router: Routerable?
    let networkService: NetworkServicing!
    let imageCacheForCells = ImageCache()
    
    var booksSearchResults: BookSearchResult? {
        didSet {
            view?.searchResultsLoaded()
        }
    }
    
    required init(view: ShelfViewable, networkService: NetworkServicing, router: Routerable) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func performSearch(by text: String) {
        networkService.searchBooks(by: text) { [unowned self](result) in
            switch result {
            case .success(let success):
                self.booksSearchResults = success
            case .failure(let error):
                self.view?.falure(error: error)
            }
        }
    }
    
    func dequeueCell(collectionView: AnyObject, indexPath: IndexPath, cellId: String) -> AnyObject? {
        guard let searchItem = booksSearchResults?.items?[indexPath.row] else {return nil}
        return router?.dequeReusableBookCell(for: collectionView, indexPath: indexPath, cellId: cellId, item: searchItem, imageCache: imageCacheForCells)
    }
}
