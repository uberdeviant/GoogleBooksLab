//
//  UIViewExtension.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(opacity: CGFloat = 0.18, radius: CGFloat = 4.0) {
        self.layer.shadowColor = UIColor.label.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.18
        self.layer.shadowRadius = 4.0
    }
    
}
