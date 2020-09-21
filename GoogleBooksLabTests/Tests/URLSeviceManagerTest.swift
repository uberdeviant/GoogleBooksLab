//
//  URLSeviceManagerTest.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 21.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

struct MockURLServiceManager: URLServiceManagable {
    
    enum MockBooksURLComponents: String {
        case scheme = "https"
        case host = "foo"
        case searchPath = "/bar"
    }
    
    enum MockBooksQueries: String {
        case searchTerm = "q"
        case startIndex = "startIndex"
        case maxResults = "maxResults"
    }
    
    func createSafeSearchUrl(startIndex: Int, searchMaxResults: Int, searchItem: String) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = MockBooksURLComponents.scheme.rawValue
        urlComponents.host = MockBooksURLComponents.host.rawValue
        urlComponents.path = MockBooksURLComponents.searchPath.rawValue
        
        //Create Queries
        urlComponents.queryItems = [
            URLQueryItem(name: MockBooksQueries.searchTerm.rawValue, value: searchItem),
            URLQueryItem(name: MockBooksQueries.startIndex.rawValue, value: "\(startIndex)"),
            URLQueryItem(name: MockBooksQueries.maxResults.rawValue, value: "\(searchMaxResults)")
        ]
        
        return urlComponents.url?.absoluteURL
    }
    
}

class URLServiceManagerTest: XCTestCase {
    var urlServiceManager: URLServiceManagable!
    
    override func setUpWithError() throws {
        urlServiceManager = MockURLServiceManager()
    }

    override func tearDownWithError() throws {
        urlServiceManager = nil
    }
    
    func testURLCreateion() {
        let searchTerm = "foo"
        let startIndex = 0
        let maxResults = 1
        
        let manualURL = URL(string: "https://foo/bar?q=\(searchTerm)&startIndex=\(startIndex)&maxResults=\(maxResults)" )
        let managedURL = urlServiceManager.createSafeSearchUrl(startIndex: startIndex, searchMaxResults: maxResults, searchItem: searchTerm)
        
        XCTAssertEqual(manualURL, managedURL)
    }
}
