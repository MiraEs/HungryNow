//
//  MealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/14/23.
//

import Foundation

public enum MealFeedLoadResult {
    case success([MealFeedItem])
    case failure(Error)
}

public protocol MealFeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (MealFeedLoadResult) -> Void)
}
