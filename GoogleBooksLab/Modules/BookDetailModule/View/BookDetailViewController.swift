//
//  BookDetailViewController.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var backShadowView: UIView! {
        didSet {
            backShadowView.addShadow()
        }
    }
    @IBOutlet weak var bookTitleImageView: UIImageView! {
        didSet {
            bookTitleImageView.clipsToBounds = true
            bookTitleImageView.contentMode = .scaleAspectFill
            bookTitleImageView.backgroundColor = .lightGray
        }
    }
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    weak var navigationLikeButton: UIButton!
    
    // MARK: - Properties
    
    var presenter: BookDetailPresentable?
    
    // MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFavNavigationButton()
        presenter?.loadImage()
        presenter?.updateLabels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addCornerRadius()
    }
    
    // MARK: - Actions
    
    @objc func likeButtonTapped(sender: UIButton) {
        navigationLikeButton.setTitleColor(.systemRed, for: .normal)
    }
}

// MARK: - Building

extension BookDetailViewController {
    private func addFavNavigationButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.setTitle("♥︎", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
        navigationLikeButton = button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationLikeButton)
    }
}

// MARK: - Presenter Dependency

extension BookDetailViewController: BookDetailViewable {
    func imageLoadFailure(error: Error) {
        //
    }
    
    func imageLoaded(imageData: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.bookTitleImageView.image = UIImage(data: imageData)
        }
    }
    
    func updateLabels(by item: BookVolume?) {
        
        bookTitleLabel.text = item?.volumeInfo.title ?? "Unknown"
        bookAuthorLabel.text = item?.volumeInfo.authors?.joined(separator: "\n") ?? "Unknown"
        
        categoryLabel.text = item?.volumeInfo.categories?.first ?? "Unknown"
        publisherLabel.text = item?.volumeInfo.publisher ?? "Unknown"
        if let pageCount = item?.volumeInfo.pageCount {
            pagesLabel.text = "\(pageCount)"
        } else {
            pagesLabel.text = "Unknown"
        }
        if let rating = item?.volumeInfo.averageRating?.starredRaiting() {
            ratingLabel.text = rating
            ratingLabel.textColor = .systemBlue
            ratingLabel.font = UIFont.systemFont(ofSize: 24)
        } else {
            ratingLabel.text = "No Rating"
            ratingLabel.textColor = .label
            ratingLabel.font = UIFont.systemFont(ofSize: 17)
        }
    }
}

// MARK: - Private Methods

extension BookDetailViewController {
    private func addCornerRadius() {
        if view.traitCollection.verticalSizeClass == .compact {
            bookTitleImageView.layer.cornerRadius = 7
            backShadowView.layer.cornerRadius = 7
        } else {
            bookTitleImageView.layer.cornerRadius = 14
            backShadowView.layer.cornerRadius = 14
        }
    }
}
