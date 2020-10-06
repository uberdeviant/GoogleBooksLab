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
    var task: URLSessionTask?
    var networkLayer: NetworkServicing?
    var imageCache: ImageCachable?
    
    init(view: PolyBookCellViewable?, imageCache: ImageCachable?, networkLayer: NetworkServicing?) {
        self.view = view
        self.imageCache = imageCache
        self.networkLayer = networkLayer
    }
    
    func needsToUpdateView(by stringURL: String?) {
        guard let link = stringURL,
            let imageURL = URL(string: link) else {
            view?.updateViews(byImage: nil)
            return
        }
        if let image = imageCache?.image(for: imageURL) {
            //If cache contains an image with the url, use it.
            view?.updateViews(byImage: image)
        } else {
            //If cache doesn't contains an image, load it from the web.
            task = networkLayer?.createLoadThumbnailTask(of: link, completion: {[weak self] (completion) in
                guard let self = self else {return}
                switch completion {
                case .success(let data):
                    //If everyrhing goes well, then save it into the cache and apply for the cell.
                    let image = UIImage(data: data)
                    self.imageCache?.insertImage(image, for: imageURL)
                    self.view?.updateViews(byImage: image)
                case .failure(_):
                    //If everyrhing has been failed, then update cell only by title.
                    self.view?.updateViews(byImage: nil)
                }
            })
            task?.resume()
        }
    }
    
    func needsToUpdateView(by item: BookObjectDescriptable?) {
        view?.updateViews(byItem: item)
    }
    
    func cancelImageTask() {
        task?.cancel() // Cancel task when reuse
    }
}
