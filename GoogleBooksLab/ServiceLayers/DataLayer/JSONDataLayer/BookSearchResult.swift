//
//  BookSearchResult.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

struct BookSearchResult: Decodable {
    let kind: String?
    let totalItems: Int?
    let items: [BookVolume]?
}
