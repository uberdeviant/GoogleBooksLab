//
//  BoolVolumeInfo.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

struct BookVolumeInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    
    let publisher: String?
    let publishedDate: String?
    let description: String?
    
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    
    let printType: String
    let mainCategory: String?
    let categories: [String]?
    
    let averageRating: Double?
    let ratingCount: Int?
    let contentVersion: String?
    
    let imageLinks: ImageLinks
    let language: String
    let previewLink: String
    let infoLink: String
    let canonicalVolumeLink: String
}

struct IndustryIdentifier: Decodable {
    let type: String
    let identifier: String
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
}
