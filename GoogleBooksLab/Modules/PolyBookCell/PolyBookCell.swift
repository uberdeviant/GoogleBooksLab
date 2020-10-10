//
//  PolyUpdatedPresenter.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 06.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation
import UIKit.UIImage

// This entities are created for cells that represent books, but they're not so different

protocol PolyBookCellViewable: class {
    func updateViews(byImage image: UIImage?) // Triggers when image loaded
    func updateViews(byItem item: BookObjectDescriptable?) // Triggers for book update
}

protocol PolyBookCellPresentable: class {
    func needsToUpdateView(by stringURL: String?)
    func needsToUpdateView(by item: BookObjectDescriptable?)
    
}

class PolyBookCellPresenter: PolyBookCellPresentable {
    
    weak var view: PolyBookCellViewable?
    var networkLayer: NetworkServicing?
    
    init(view: PolyBookCellViewable?, networkLayer: NetworkServicing?) {
        self.view = view
        self.networkLayer = networkLayer
    }
    
    func needsToUpdateView(by stringURL: String?) {
        guard let stringLink = stringURL else {
            return
        }
        
        networkLayer?.loadThumbnail(of: stringLink, completion: { [weak self] (completion) in
            switch completion {
            case .success(let data):
                let image = UIImage(data: data)
                self?.view?.updateViews(byImage: image)
            case .failure(_):
                self?.view?.updateViews(byImage: nil)
            }
        })
    }
    
    func needsToUpdateView(by item: BookObjectDescriptable?) {
        view?.updateViews(byItem: item)
    }
    
}
