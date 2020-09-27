//
//  NetworkService.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol NetworkServicing {
    func searchBooks(by text: String, completion: @escaping (Result<BookSearchResult?, Error>) -> Void)
    func createLoadThumbnailTask(of stringURL: String, completion: @escaping(Result<Data, Error>) -> Void) -> URLSessionDataTask?
}

class NetworkService: NetworkServicing {
    
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
    
    func createLoadThumbnailTask(of stringURL: String, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        
        guard let url = URL(string: stringURL) else {
            completion(.failure(NetworkErrors.invalidURL))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        
        return task
    }
}
