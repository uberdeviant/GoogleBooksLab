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
    
    init(view: ShelfViewable, imageCache: ImageCachable, networkService: NetworkServicing, router: Routerable)
    
    // MARK: - Network
    
    func performSearch(by text: String)
    
    // MARK: - Cache
    
    func clearCache()
    
    // MARK: - Navigation
    
    func dequeueCell(collectionView: AnyObject, indexPath: IndexPath, cellId: String) -> BookCollectionViewCell?
    
    func goToDetail(bookId: String?)
    
    func goToFavourites()
}

class ShelfPresenter: ShelfPresentable {
    
    weak var view: ShelfViewable?
    var router: Routerable?
    let networkService: NetworkServicing!
    let imageCacheForCells: ImageCachable!
    
    var booksSearchResults: BookSearchResult? {
        didSet {
            view?.searchResultsLoaded()
        }
    }
    
    required init(view: ShelfViewable, imageCache: ImageCachable, networkService: NetworkServicing, router: Routerable) {
        self.view = view
        self.networkService = networkService
        self.imageCacheForCells = imageCache
        self.router = router
    }
    
    func clearCache() {
        imageCacheForCells.removeAllImages()
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
    
    func dequeueCell(collectionView: AnyObject, indexPath: IndexPath, cellId: String) -> BookCollectionViewCell? {
        guard let searchItem = booksSearchResults?.items?[indexPath.row] else {return nil}
        return router?.dequeReusableBookCell(for: collectionView, indexPath: indexPath, cellId: cellId, item: searchItem, imageCache: imageCacheForCells)
    }
    
    func goToDetail(bookId: String?) {
        guard let items = booksSearchResults?.items, let bookId = bookId else {return}
        for book in items where book.id == bookId {
            router?.instantiateDetailViewController(by: book)
            break // O(log n) ?
        }
    }
    
    func goToFavourites() {
        router?.instantiateFavouriteBooks(imageCahe: imageCacheForCells)
    }
}
