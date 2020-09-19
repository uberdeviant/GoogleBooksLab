//
//  DoubleExtensions.swift
//  GoogleBooksLab
//
//  Created by Ramil Salimov on 19.09.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import Foundation

extension Double {
    func starredRaiting() -> String {
        var stars: String = ""
        var value = self
        while value > 0 {
            value -= 0.5
            if let lastStar = stars.last {
                if lastStar == "⭐︎"{
                    stars.removeLast()
                    stars.append("⭑")
                } else {
                    stars.append("⭐︎")
                }
            } else {
                stars.append("⭐︎")
            }
        }
        return stars != "" ? stars : "No Raiting"
    }
}
