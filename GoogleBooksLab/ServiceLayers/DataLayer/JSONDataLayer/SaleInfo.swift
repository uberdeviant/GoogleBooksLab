//
//  SaleInfo.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

struct SaleInfo: Decodable {
    let country: String
    let saleability: String
    let onSaleDate: Date?
    let isEbook: Bool
    let listPrice: ListPrice?
    let retailPrice: RetailPrice?
    let buyLink: String?
}

struct ListPrice: Decodable {
    let amount: Double
    let currencyCode: String
}

struct RetailPrice: Decodable {
    let amount: Double
    let currencyCode: String
}
