//
//  ImageCache.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol ImageDataCachable: class {
    // Returns the image associated with a given url
    func imageData(for url: URL) -> NSData?
    // Inserts the image of the specified url in the cache
    func insertImageData(_ imageData: NSData?, for url: URL)
    // Removes the image of the specified url in the cache
    func removeImageData(for url: URL)
    // Removes all images from the cache
    func removeAllImageData()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> NSData? { get set }
}

final class ImageDataCache {

    // 1st level cache, that contains encoded images
    private lazy var imageDataCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config: Config

    struct Config {
        let countLimit: Int

        static let defaultConfig = Config(countLimit: 200)
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageDataCache: ImageDataCachable {
    func imageData(for url: URL) -> NSData? {
        lock.lock(); defer { lock.unlock() }
        
        // search for image data
        if let data = imageDataCache.object(forKey: url as AnyObject) as? NSData {
            return data
        }
        return nil
    }
    
    func removeAllImageData() {
        lock.lock(); defer { lock.unlock() }
        imageDataCache.removeAllObjects()
    }
    
    subscript(_ key: URL) -> NSData? {
        get {
            return imageData(for: key)
        }
        set {
            return insertImageData(newValue, for: key)
        }
    }
    
    func insertImageData(_ imageData: NSData?, for url: URL) {
        guard let imageData = imageData else { return removeImageData(for: url) }

        lock.lock(); defer { lock.unlock() }
        imageDataCache.setObject(imageData, forKey: url as AnyObject)
    }

    func removeImageData(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageDataCache.removeObject(forKey: url as AnyObject)
    }
}
