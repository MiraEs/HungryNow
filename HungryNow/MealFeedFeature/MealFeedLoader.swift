//
//  MealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/14/23.
//

import Foundation

enum MealFeedLoadResult {
    case success([MealFeedItem])
    case failure(Error)
}

protocol MealFeedLoader {
    func load(complation: @escaping (MealFeedLoadResult) -> Void)
}
