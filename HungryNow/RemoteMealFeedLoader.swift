//
//  RemoteMealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/15/23.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

class RemoteMealFeedLoader {
    let client: HTTPClient
    let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    init(client: HTTPClient,
         url: URL = URL(string:"www.a-url.com")!) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Error) -> Void = { _ in}) {
        client.get(from: url, completion: { error in
            completion(.connectivity)
        })
    }
}
