//
//  RemoteMealFeedLoaderTests.swift
//  HungryNowTests
//
//  Created by Mir on 11/14/23.
//

import XCTest
@testable import HungryNow


final class RemoteMealFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_init_requestsDataFromURL() {
        let url = URL(string: "www.given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data("{\"meals\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item = makeItem(name: "dessert", url: URL(string: "dessert.com"), id: "1234")
        let item2 = makeItem(name: "dessert2", url: URL(string: "dessert2.com"), id: "2345")
        
        let items = [item.json, item2.json]
        
        expect(sut, toCompleteWith: .success([item.model, item2.model])) {
            let json = makeItemsJSON(items)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (sut: RemoteMealFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMealFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private func makeItem(name: String? = nil, url: URL? = nil, id: String? = nil) -> (model: MealFeedItem, json: [String: Any]) {
        
        let item = MealFeedItem(name: name, url: url, id: id)
        
        let json = [
            "strMeal": name,
            "strMealThumb": url?.absoluteString,
            "idMeal": id
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let itemsJSON = ["meals": items]
        return try! JSONSerialization.data(withJSONObject: itemsJSON)
        
        
    }
    
    private func expect(_ sut: RemoteMealFeedLoader, toCompleteWith result: RemoteMealFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults = [RemoteMealFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
        
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        var completions = [(HTTPClientResult) -> Void]()
        
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
        
        
    }
}
