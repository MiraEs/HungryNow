//
//  RemoteMealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/15/23.
//

import Foundation

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

class RemoteMealFeedLoader {
    let client: HTTPClient
    let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([MealFeedItem])
        case failure(Error)
    }
    
    init(client: HTTPClient,
         url: URL = URL(string:"www.a-url.com")!) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}


private class FeedItemsMapper {
    struct Root: Decodable {
        let meals: [Meal]
    }

    // Create private struct to prevent exposing API knowledge (previously solved via coding keys)
    struct Meal: Decodable {
        var strMeal: String?
        var strMealThumb: URL?
        var idMeal: String?
        
        var meal: MealFeedItem {
            return MealFeedItem(name: strMeal, url: strMealThumb, id: idMeal)
        }
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [MealFeedItem] {
        guard response.statusCode == 200 else {
            throw RemoteMealFeedLoader.Error.invalidData
        }
        return try JSONDecoder().decode(Root.self, from: data).meals.map { $0.meal }
    }
}
