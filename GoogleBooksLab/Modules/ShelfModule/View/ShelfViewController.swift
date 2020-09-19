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
            searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        }
    }
    
    @IBOutlet weak var shelfCollectionView: UICollectionView! {
        didSet {
            shelfCollectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCellID)
            shelfCollectionView.delegate = self
            shelfCollectionView.dataSource = self
        }
    }
    
    // MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Google Books"
        presenter?.performSearch(by: "Swift") //First search while app doesn't have DB with favourits
    }
    
    // MARK: - Properties
    
    private let bookCellID = "bookCell"
    
    var presenter: ShelfPresentable?
    
}

// MARK: Search Bar Delegate

extension ShelfViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter?.performSearch(by: text)
        }
    }
}

// MARK: Collection View Delegate

extension ShelfViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 15)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: Collection View DataSource

extension ShelfViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.booksSearchResults?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = presenter?.dequeueCell(collectionView: collectionView, indexPath: indexPath, cellId: bookCellID) {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell else {return}
        animateSelectionAndPerformSegue(of: cell)
    }
    
    private func animateSelectionAndPerformSegue(of cell: BookCollectionViewCell) {
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            cell.alpha = 0.8
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .identity
                cell.alpha = 1
            }) { [weak self] (_) in
                self?.presenter?.goToDetail(bookId: cell.presenter?.bookID)
            }
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
