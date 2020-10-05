//
//  ObjectDescriptable.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 05.10.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

typealias BookObjectDescription = (volumeID: String?,
                                   title: String?,
                                   authors: [String]?,
                                   categories: [String]?,
                                   publisher: String?,
                                   pageCount: Int64?,
                                   rating: Double?,
                                   smallThumbnail: String?,
                                   thumbnail: String?)

protocol BookObjectDescriptable {
    var bookDescription: BookObjectDescription {get}
}
