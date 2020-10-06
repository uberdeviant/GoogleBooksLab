//
//  FavouriteTableViewCell.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 29.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    var presenter: FavouriteCellPresenter?
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = 12
            backView.addShadow()
        }
    }
    @IBOutlet weak var bookImageView: UIImageView! {
        didSet {
            bookImageView.clipsToBounds = true
            bookImageView.layer.cornerRadius = 12
            bookImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func updateCellBy(bookModel: BookExtendedInfoModel) {
        titleLabel.text = bookModel.title
        authorsLabel.text = bookModel.authors?.joined(separator: "\n")
        categoryLabel.text = bookModel.categories?.first
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
        authorsLabel.text = nil
        categoryLabel.text = nil
        
        presenter?.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Presenter dependency

extension FavouriteTableViewCell: PolyBookCellViewable {
    
    func updateViews(byImage image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.bookImageView?.image = image
        }
    }
    
    func updateViews(byItem item: BookObjectDescriptable?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.titleLabel.text = item?.bookDescription.title ?? "Unknown"
            self.authorsLabel.text = item?.bookDescription.authors?.joined(separator: "\n") ?? "Unknown"
            self.categoryLabel.text = item?.bookDescription.categories?.first ?? "Unknown"
        }
    }
}
