//
//  NetworkService.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

protocol NetworkServicing {
    func getComments(completion: @escaping (Result<[String]?, Error>) -> Void)
}

class NetworkService: NetworkServicing {
    func getComments(completion: @escaping (Result<[String]?, Error>) -> Void) {
        //
    }
}
