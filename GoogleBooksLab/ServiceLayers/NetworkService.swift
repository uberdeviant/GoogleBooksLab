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
}

class NetworkService: NetworkServicing {
    func searchBooks(by text: String, completion: @escaping (Result<BookSearchResult?, Error>) -> Void) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=" + text
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else { print("nil search data"); return }
                let searchResults = try JSONDecoder().decode(BookSearchResult.self, from: data)
                completion(.success(searchResults))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
