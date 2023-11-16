//
//  MealFeedItem.swift
//  HungryNow
//
//  Created by Mir on 11/14/23.
//

import Foundation

struct MealFeedItem: Equatable {
    var name: String?
    var url: URL?
    var id: String?
    
    public init(name: String?, url: URL?, id: String?) {
        self.name = name
        self.url = url
        self.id = id
    }
}

extension MealFeedItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case url = "strMealThumb"
        case id = "idMeal"
    }
}

