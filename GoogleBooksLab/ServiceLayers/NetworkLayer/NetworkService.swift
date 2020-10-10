//
//  NetworkService.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol NetworkServicing {
    
    init(cache: ImageDataCachable)
    
    func searchBooks(by text: String, completion: @escaping (Result<BookSearchResult?, Error>) -> Void)
    func loadThumbnail(of stringURL: String, completion: @escaping(Result<Data, Error>) -> Void)
    
    func clearCache()
}

class NetworkService: NetworkServicing {
    
    private var imageDataCachable: ImageDataCachable?
    
    required init(cache: ImageDataCachable) {
        self.imageDataCachable = cache
    }
    
    func searchBooks(by text: String, completion: @escaping (Result<BookSearchResult?, Error>) -> Void) {
        
        guard let url = NetworkAPIModel.search(searchText: text).url else {
            completion(.failure(NetworkErrors.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else { completion(.failure(NetworkErrors.nullDataFetched)); return }
                let searchResults = try JSONDecoder().decode(BookSearchResult.self, from: data)
                completion(.success(searchResults))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func loadThumbnail(of stringURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = NetworkAPIModel.getThumbnail(stringURL: stringURL).url else {
            completion(.failure(NetworkErrors.invalidURL))
            return
        }
        
        if let imageData = imageDataCachable?[url] {
            completion(.success(imageData as Data))
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                self?.imageDataCachable?[url] = data as NSData
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    func clearCache() {
        imageDataCachable?.removeAllImageData()
    }
}
