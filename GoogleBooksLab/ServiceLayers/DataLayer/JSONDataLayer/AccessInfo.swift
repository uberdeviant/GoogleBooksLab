//
//  AccessInfo.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

struct AccessInfo: Decodable {
    let country: String
    let viewability: String
    let embeddable: Bool
    let publicDomain: Bool
    let textToSpeechPermission: String
    let epub: BookFormat
    let pdf: BookFormat
    let webReaderLink: String
    let accessViewStatus: String
    
    // MARK: - ToDo downloadAccess
    
    let searchInfo: SearchInfo?
    
}

struct BookFormat: Decodable {
    let isAvailable: Bool
    let downloadLink: String?
    let acsTokenLink: String?
}

struct SearchInfo: Decodable {
    let textSnippet: String
}
