//
//  ShelfPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol ShelfViewable: class {
    func defaultBooksLoaded()
    func falure(error: Error)
}

protocol ShelfPresentable: class {
    init(view: ShelfViewable, networkService: NetworkServicing, router: Routerable)
}

class ShelfPresenter: ShelfPresentable {
    
    weak var view: ShelfViewable?
    var router: Routerable?
    let networkService: NetworkServicing!
    
    required init(view: ShelfViewable, networkService: NetworkServicing, router: Routerable) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
}
