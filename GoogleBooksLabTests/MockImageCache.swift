//
//  MockImageCache.swift
//  GoogleBooksLabTests
//
//  Created by Ramil Salimov on 20.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import XCTest
@testable import GoogleBooksLab

class MockImageCache: ImageCachable {
    
    var cache: [URL: UIImage] = [:]
    
    func image(for url: URL) -> UIImage? {
        return cache[url]
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        cache[url] = image
    }
    
    func removeImage(for url: URL) {
        cache.removeValue(forKey: url)
    }
    
    func removeAllImages() {
        cache.removeAll()
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            return image(for: url)
        }
        set(newValue) {
            return insertImage(newValue, for: url)
        }
    }
}
