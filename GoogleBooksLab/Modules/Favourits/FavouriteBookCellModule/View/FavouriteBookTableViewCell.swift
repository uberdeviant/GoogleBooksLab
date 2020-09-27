//
//  FavouriteBookTableViewCell.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 27.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class FavouriteBookTableViewCell: UITableViewCell {
    
    weak var bookThumbnailImageView: UIImageView!
    weak var titleBookLabel: UILabel!
    weak var authorsBookLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Building

extension FavouriteBookTableViewCell {
    private func createUI() {
        createImage(with: 12)
        addLabels()
    }
    
    private func createImage(with cornerRadius: CGFloat) {
        //We need backShadowView because imageView has to be clipped to bound, we can clip image and add shadow at the same time
        let backShadowView = UIView()
        backShadowView.layer.cornerRadius = cornerRadius
        backShadowView.backgroundColor = .lightGray
        backShadowView.addShadow()
        
        self.addSubview(backShadowView)
        backShadowView.translatesAutoresizingMaskIntoConstraints = false
        backShadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        backShadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        backShadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        backShadowView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        backShadowView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.5).isActive = true // 6:4 aspect ratio
        backShadowView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: 15).isActive = true
        
        //Creation
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        bookThumbnailImageView = imageView
        backShadowView.addSubview(bookThumbnailImageView)
        //Constraints
        bookThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        bookThumbnailImageView.centerXAnchor.constraint(equalTo: backShadowView.centerXAnchor).isActive = true
        bookThumbnailImageView.centerYAnchor.constraint(equalTo: backShadowView.centerYAnchor).isActive = true
        bookThumbnailImageView.widthAnchor.constraint(equalTo: backShadowView.widthAnchor).isActive = true
        bookThumbnailImageView.heightAnchor.constraint(equalTo: backShadowView.heightAnchor).isActive = true
    }
    
    private func addLabels() {
        //Creation
        titleBookLabel = createLabel(with: UIFont.preferredFont(forTextStyle: .headline))
        authorsBookLabel = createLabel(with: UIFont.preferredFont(forTextStyle: .body))
        
        self.addSubview(titleBookLabel)
        self.addSubview(authorsBookLabel)
        
        //Constraints
        titleBookLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleBookLabel.leadingAnchor.constraint(equalTo: self.bookThumbnailImageView.trailingAnchor, constant: 15).isActive = true
        titleBookLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        titleBookLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        
        authorsBookLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorsBookLabel.leadingAnchor.constraint(equalTo: self.bookThumbnailImageView.trailingAnchor, constant: 15).isActive = true
        authorsBookLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        authorsBookLabel.topAnchor.constraint(equalTo: titleBookLabel.bottomAnchor, constant: 15).isActive = true
        authorsBookLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
    }
    
    private func createLabel(with font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = font
        label.textColor = .label
        label.numberOfLines = 0
        
        return label
    }
}
