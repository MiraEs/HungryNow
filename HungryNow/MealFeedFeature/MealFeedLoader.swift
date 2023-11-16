//
//  MealFeedLoader.swift
//  HungryNow
//
//  Created by Mir on 11/14/23.
//

import Foundation

public enum MealFeedLoadResult<Error: Swift.Error> {
    case success([MealFeedItem])
    case failure(Error)
}

extension MealFeedLoadResult: Equatable where Error: Equatable {}

protocol MealFeedLoader {
    associatedtype Error: Swift.Error
    func load(complation: @escaping (MealFeedLoadResult<Error>) -> Void)
}
