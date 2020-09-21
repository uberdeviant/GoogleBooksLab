//
//  URLServiceManager.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 21.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol URLServiceManagable {
    //by using this protocol we can create any URL search manager
    func createSafeSearchUrl(startIndex: Int, searchMaxResults: Int, searchItem: String) -> URL?
}

struct GoogleURLServiceManger: URLServiceManagable {
    
    enum GoogleBooksURLComponents: String {
        case scheme = "https"
        case host = "www.googleapis.com"
        case searchPath = "/books/v1/volumes"
    }
    
    enum GoogleBooksQueries: String {
        case searchTerm = "q"
        case startIndex = "startIndex"
        case maxResults = "maxResults"
    }
    
    func createSafeSearchUrl(startIndex: Int, searchMaxResults: Int, searchItem: String) -> URL? {
        var urlComponents = URLComponents()
        
        //Create URLComponents
        urlComponents.scheme = GoogleBooksURLComponents.scheme.rawValue
        urlComponents.host = GoogleBooksURLComponents.host.rawValue
        urlComponents.path = GoogleBooksURLComponents.searchPath.rawValue
        
        //Create Queries
        urlComponents.queryItems = [
            URLQueryItem(name: GoogleBooksQueries.searchTerm.rawValue, value: searchItem),
            URLQueryItem(name: GoogleBooksQueries.startIndex.rawValue, value: "\(startIndex)"),
            URLQueryItem(name: GoogleBooksQueries.maxResults.rawValue, value: "\(searchMaxResults)")
        ]
        
        return urlComponents.url?.absoluteURL
    }
}
