//
//  ShelfViewController.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var shelfCollectionView: UICollectionView! {
        didSet {
            shelfCollectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCellID)
            shelfCollectionView.delegate = self
            shelfCollectionView.dataSource = self
        }
    }
    
    // MARK: - Properties
    
    private let bookCellID = "bookCell"
    
    var presenter: ShelfPresentable?
    
}

// MARK: Collection View Delegate

extension ShelfViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 15)
    }
}

// MARK: Search Bar Delegate

extension ShelfViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter?.performSearch(by: text)
        }
    }
}

// MARK: Collection View DataSource

extension ShelfViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.booksSearchResults?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = presenter?.dequeueCell(collectionView: collectionView, indexPath: indexPath, cellId: bookCellID) as? UICollectionViewCell {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
}

// MARK: Presenter dependency

extension ShelfViewController: ShelfViewable {
    func searchResultsLoaded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.shelfCollectionView.reloadData()
        }
    }
    
    func falure(error: Error) {
        print("ERROR", error)
    }
    
}
