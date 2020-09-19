//
//  ShelfViewController.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {
    
    private let bookCellID = "bookCell"

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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.performSearch(by: searchText)
    }
}

// MARK: Collection View DataSource

extension ShelfViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.booksSearchResults?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bookCellID, for: indexPath) as? BookCollectionViewCell,
            let item = presenter?.booksSearchResults?.items?[indexPath.row] else {return UICollectionViewCell()}
        
        return cell
    }
    
}

// MARK: Presenter dependency

extension ShelfViewController: ShelfViewable {
    func searchResultsLoaded() {
        print(presenter?.booksSearchResults?.items)
        DispatchQueue.main.async {
            self.shelfCollectionView.reloadData()
        }
        
    }
    
    func falure(error: Error) {
        print("ERROR", error)
    }
    
}
