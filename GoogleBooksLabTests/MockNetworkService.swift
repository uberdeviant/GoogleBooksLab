//
//  MockingNetworkService.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockNetworkService: NetworkServicing {
    
    var successThumbnail: Bool
    
    init(successThumbnail: Bool = true) {
        self.successThumbnail = successThumbnail
    }
    
    func searchBooks(by text: String, completion: @escaping (Result<BookSearchResult?, Error>) -> Void) {
        if text == "error" {
            completion(.failure(NSError(domain: "foo", code: 0, userInfo: nil)))
        } else {
            completion(.success(returnMockSearchBook()))
        }
    }
    
    func loadThumbnail(of url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        if successThumbnail {
            completion(.success(Data()))
        } else {
            completion(.failure(NSError(domain: "foo", code: 0, userInfo: nil)))
        }
        return URLSession.shared.dataTask(with: URLRequest(url: URL(string: "foo")!))
    }
    
}

// MARK: - Create mock result

extension MockNetworkService {
    private func returnMockSearchBook() -> BookSearchResult {
        
        let bookFormat = BookFormat(isAvailable: false, downloadLink: nil, acsTokenLink: nil)
        
        let accessInfo = AccessInfo(country: "foo", viewability: "bar", embeddable: false, publicDomain: false, textToSpeechPermission: "foo", epub: bookFormat, pdf: bookFormat, webReaderLink: "foo", accessViewStatus: "bar", searchInfo: SearchInfo(textSnippet: "foo"))
       
        let saleInfo = SaleInfo(country: "foo", saleability: "bar", onSaleDate: nil, isEbook: false, listPrice: nil, retailPrice: nil, buyLink: nil)
        
        // Need to do something with it, maybe create default init
        let bookVolumeInfo = BookVolumeInfo(title: "foo",
                                            subtitle: nil,
                                            authors: nil,
                                            publisher: nil,
                                            publishedDate: nil,
                                            description: nil,
                                            industryIdentifiers: nil,
                                            pageCount: nil,
                                            printType: "foo",
                                            mainCategory: nil,
                                            categories: nil,
                                            averageRating: nil,
                                            ratingCount: nil,
                                            contentVersion: nil,
                                            imageLinks: nil,
                                            language: "foo",
                                            previewLink: "foo",
                                            infoLink: "bar",
                                            canonicalVolumeLink: "foo")
        
        let bookVolume = [
            BookVolume(kind: "foo", id: "bar", etag: "foo", selfLink: "bar", volumeInfo: bookVolumeInfo, saleInfo: saleInfo, accessInfo: accessInfo)
        ]
        
        return BookSearchResult(kind: "foo", totalItems: 1, items: bookVolume)
    }
}
