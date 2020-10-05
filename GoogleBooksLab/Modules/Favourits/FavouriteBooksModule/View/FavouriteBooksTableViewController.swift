//
//  FavouriteBooksTableViewController.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 27.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class FavouriteBooksTableViewController: UITableViewController {

    // MARK: - Properties
    
    var presenter: FavouriteBooksPresentable?
    
    private let favouriteCellID = "favouriteCellID"
    
    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        presenter?.loadBooks()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.favouriteBooks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = presenter?.dequeueCell(tableView: tableView, indexPath: indexPath, cellId: favouriteCellID) {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteBook(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.rowSelected(at: indexPath)
    }

}

// MARK: - Building

extension FavouriteBooksTableViewController {
    private func updateTableView() {
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cellNib = UINib(nibName: "FavouriteTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: favouriteCellID)
    }
}

// MARK: - Presenter Dependency

extension FavouriteBooksTableViewController: FavouriteBooksViewable {
    func objectDeleted(at indexPath: IndexPath) {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func dataLoaded() {
        tableView.reloadData()
    }
}
