//
//  NetworkErrors.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 27.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case nullDataFetched
}

extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("URL from given string value could not be created", comment: "localised custom error")
        case .nullDataFetched:
            return NSLocalizedString("Fetched data is equal nil", comment: "localised custom error")
        }
    }
}
