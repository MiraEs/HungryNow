//
//  RemoteFeedItemsMapper.swift
//  HungryNow
//
//  Created by Mir on 11/16/23.
//

import Foundation

final class RemoteFeedItemsMapper {
    private struct Root: Decodable {
        let meals: [Meal]
        
        var feed: [MealFeedItem] {
            return meals.map { $0.meal }
        }
    }

    // Create private struct to prevent exposing API knowledge (previously solved via coding keys)
    private struct Meal: Decodable {
        var strMeal: String?
        var strMealThumb: URL?
        var idMeal: String?
        
        var meal: MealFeedItem {
            return MealFeedItem(name: strMeal, url: strMealThumb, id: idMeal)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteMealFeedLoader.Result {
        
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)  else {
            return .failure(.invalidData)
        }
        
        return .success(root.feed)
    }
}
