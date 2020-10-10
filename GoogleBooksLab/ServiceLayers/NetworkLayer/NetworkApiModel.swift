//
//  NetworkApiModel.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 26.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

typealias SearchAmount = (startIndex: Int, maxResults: Int)

enum NetworkAPIModel {
    
    case search(searchText: String, searchAmount: SearchAmount = (startIndex: 0, maxResults: 25))
    
    case getThumbnail(stringURL: String)
    
    var url: URL? {
        switch self {
        case .getThumbnail(stringURL: let stringURL):
            return URL(string: stringURL)
        default:
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = baseUrl
            urlComponents.path = path
            urlComponents.queryItems = queryParamters.map {URLQueryItem(name: $0.0, value: $0.1)}
            return urlComponents.url
        }
    }
}

// MARK: - Private computed properties
extension NetworkAPIModel {
    
    private var scheme: String {
        return "https"
    }
    
    private var baseUrl: String {
        return "www.googleapis.com"
    }
    
    private var path: String {
        switch self {
        case .search:
            return "/books/v1/volumes"
        case .getThumbnail:
            return ""
        }
    }
    private var queryParamters: [String: String] {
        switch self {
        case .search(let text, let searchAmount):
            return ["q": text,
                    "startIndex": "\(searchAmount.startIndex)",
                    "maxResults": "\(searchAmount.maxResults)"]
        case .getThumbnail:
            return [:]
        }
    }
}
