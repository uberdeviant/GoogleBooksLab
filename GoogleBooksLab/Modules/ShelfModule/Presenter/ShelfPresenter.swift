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
    
    func clearCache() {
        networkService.clearCache()
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
        return router?.dequeReusableBookCell(for: collectionView, indexPath: indexPath, cellId: cellId, item: searchItem)
    }
    
    func goToDetail(bookId: String?) {
        guard let items = booksSearchResults?.items, let bookId = bookId else {return}
        for book in items where book.id == bookId {
            router?.instantiateDetailViewController(by: book, needsToPush: true)
            break // O(log n) ?
        }
    }
    
    func goToFavourites() {
        router?.instantiateFavouriteBooks()
    }
}
