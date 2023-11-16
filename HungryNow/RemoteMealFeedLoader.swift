//
//  RemoteMealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/15/23.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteMealFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient,
         url: URL = URL(string:"www.a-url.com")!) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}
