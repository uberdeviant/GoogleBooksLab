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
        // #warning Incomplete implementation, return the number of rows
        return presenter?.favouriteBooks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = presenter?.dequeueCell(tableView: tableView, indexPath: indexPath, cellId: favouriteCellID) {
            return cell
        } else {
            return UITableViewCell()
        }
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
    func dataLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print(self.presenter!.favouriteBooks.count)
            for book in self.presenter!.favouriteBooks {
                print(book.bookExtendedInfoModel?.title)
            }
        }
    }
}
