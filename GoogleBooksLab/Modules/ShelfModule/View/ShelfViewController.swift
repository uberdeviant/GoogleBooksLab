//
//  ShelfViewController.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var shelfCollectionView: UICollectionView!
    
    var presenter: ShelfPresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ShelfViewController: ShelfViewable {
    func defaultBooksLoaded() {
        //
    }
    
    func falure(error: Error) {
        //
    }
    
}
