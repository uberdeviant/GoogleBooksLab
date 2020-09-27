//
//  ShelfCollectionViewController.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class ShelfCollectionViewController: UICollectionViewController {

    // MARK: - UI Properties
    
    weak var favoutitesButton: UIButton!
    var searchController: UISearchController!
    
    // MARK: - Properties
    
    private let bookCellID = "bookCell"
    
    var presenter: ShelfPresentable?
    
    // MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        createSearchBar()
        addFavButton()
    }
    
    // MARK: Actions
    
    @objc func favouritsButtonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            } completion: { (_) in
                //goto favourits
            }

        }

    }
    
}

// MARK: Search Bar Delegate

extension ShelfCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter?.clearCache()
            presenter?.performSearch(by: text)
        }
    }
}

// MARK: Collection View

extension ShelfCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 30)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController.searchBar.endEditing(true)
    }
}

// MARK: Collection View DataSource

extension ShelfCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.booksSearchResults?.items?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = presenter?.dequeueCell(collectionView: collectionView, indexPath: indexPath, cellId: bookCellID) {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell else {return}
        animateSelectionAndPerformSegue(of: cell)
    }
    
    // Animation
    private func animateSelectionAndPerformSegue(of cell: BookCollectionViewCell) {
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
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

extension ShelfCollectionViewController: ShelfViewable {
    func searchResultsLoaded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.collectionView.reloadData()
            self.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 100, height: 10), animated: true)
        }
    }
    
    func falure(error: Error) {
        print("ERROR", error)
    }
    
}

// MARK: - Building

extension ShelfCollectionViewController {
    private func updateUI() {
        self.title = "Google Books"
        self.collectionView.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCellID)
        presenter?.performSearch(by: "Book") //First search while app doesn't have DB with favourits
        
    }
    
    private func createSearchBar() {
        self.searchController = UISearchController()

        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
    }
    
    private func addFavButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setTitle("♥︎", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        button.setTitleColor(UIColor.systemBackground.withAlphaComponent(0.7), for: .normal)
        button.backgroundColor = UIColor.label.withAlphaComponent(0.7)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.layer.cornerRadius = button.bounds.height / 2
        
        button.addTarget(self, action: #selector(favouritsButtonTapped(sender:)), for: .touchUpInside)
        button.addShadow()
        
        favoutitesButton = button
    }
}
