//
//  RemoteMealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/15/23.
//

import Foundation

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
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
