//
//  BookVolume.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

struct BookVolume: Decodable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    
    let volumeInfo: BookVolumeInfo
    
    // MARK: - ToDo UserInfo
    
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
}
