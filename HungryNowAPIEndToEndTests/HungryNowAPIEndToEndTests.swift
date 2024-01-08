//
//  HungryNowAPIEndToEndTests.swift
//  HungryNowAPIEndToEndTests
//
//  Created by Mir on 12/18/23.
//

import XCTest
@testable import HungryNow

final class HungryNowAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        let testServerURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=breakfast")!
                                    //"https://www.themealdb.com/api/json/v1/1/filter.php?c=dessert")!
                                    //"http://www.themealdb.com/api/json/v1/1/list.php?c=list")! //"https://www.themealdb.com/api/json/v1/1/categories.php")!
        let client = URLSessionHTTPClient()
        let loader = RemoteMealFeedLoader(client: client, url: testServerURL)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: MealFeedLoadResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(items)?:
            XCTAssertEqual(items.count, 8, "Expected 8 items in the test account feed")
            
        items.enumerated().forEach { (index, item) in
            XCTAssertEqual(item, expectedItem(at: index))
        }
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    private func expectedItem(at index: Int) -> MealFeedItem {
        return MealFeedItem(name: name(at: index), url: url(at: index), id: id(at: index))
    }
    
    private func name(at index: Int) -> String? {
        return ["Bread omelette", 
                "Breakfast Potatoes",
                "English Breakfast",
                "Fruit and Cream Cheese Breakfast Pastries",
                "Full English Breakfast",
                "Home-made Mandazi",
                "Salmon Eggs Eggs Benedict",
                "Smoked Haddock Kedgeree"
        ][index]
    }
    
    private func url(at index: Int) -> URL? {
        return URL(string: [
        "https://www.themealdb.com/images/media/meals/hqaejl1695738653.jpg",
        "https://www.themealdb.com/images/media/meals/1550441882.jpg",
        "https://www.themealdb.com/images/media/meals/utxryw1511721587.jpg",
        "https://www.themealdb.com/images/media/meals/1543774956.jpg",
        "https://www.themealdb.com/images/media/meals/sqrtwu1511721265.jpg",
        "https://www.themealdb.com/images/media/meals/thazgm1555350962.jpg",
        "https://www.themealdb.com/images/media/meals/1550440197.jpg",
        "https://www.themealdb.com/images/media/meals/1550441275.jpg",
        ][index])!
    }
    
    private func id(at index: Int) -> String? {
        return ["53076",
                "52965",
                "52895",
                "52957",
                "52896",
                "52967",
                "52962",
                "52964"
        ][index]
    }
 
}
