//
//  BookCollectionViewCell.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    weak var bookThumbnailImageView: UIImageView!
    weak var titleBookLabel: UILabel!
    
    var presenter: BookCellPresentable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookThumbnailImageView.image = nil
        titleBookLabel.text = nil
        presenter?.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Presenter Dependency

extension BookCollectionViewCell: PolyBookCellViewable {
    func updateViews(byImage image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.bookThumbnailImageView.image = image
        }
    }
    
    func updateViews(byItem item: BookObjectDescriptable?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.titleBookLabel.text = item?.bookDescription.title
        }
    }
}

// MARK: - Building and animation

extension BookCollectionViewCell {
    
    private func createUI() {
        createImageView(with: 12)
        createLabel()
    }
    
    private func createImageView(with cornerRadius: CGFloat) {
        //We need backShadowView because imageView has to be clipped to bound, we can clip image and add shadow at the same time
        let backShadowView = UIView()
        backShadowView.layer.cornerRadius = cornerRadius
        backShadowView.backgroundColor = .lightGray
        backShadowView.addShadow()
        
        self.contentView.addSubview(backShadowView)
        backShadowView.translatesAutoresizingMaskIntoConstraints = false
        backShadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        backShadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8).isActive = true
        backShadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
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
    
    private func createLabel() {
        //Creation
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 3
        
        titleBookLabel = label
        self.contentView.addSubview(titleBookLabel)
        //Constraints
        titleBookLabel.translatesAutoresizingMaskIntoConstraints = false
        titleBookLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        titleBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        titleBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8).isActive = true
        titleBookLabel.topAnchor.constraint(equalTo: bookThumbnailImageView.bottomAnchor, constant: 8).isActive = true
        titleBookLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
        
    }
    
}
