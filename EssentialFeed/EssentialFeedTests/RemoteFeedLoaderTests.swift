//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doestNotRequestDataFromUrl(){
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromUrl(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{_ in}
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromUrlTwice(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{_ in}
        sut.load{_ in}
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliverErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity), when: {
                let clientError = NSError(domain: "Test", code: 0)
                client.complete(with: clientError)
        })
    }
    
    func test_load_deliverErrorOnNon200HTTPResponse(){
        let (sut, client) = makeSUT()
        
        let samples = [191,201,300,400,500]
        samples.enumerated().forEach{index,code in
            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
        
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
            let invalidJson = Data(bytes: "InvalidJson".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
    }
    
    func test_load_deliverNoitemsOn200HTTPResponseWithEmptyJSONList(){
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJson = Data(bytes: "{\"items\":[]}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJson)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems(){
        let (sut, client) = makeSUT()
        
        
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://www.a-utl.com")!)
       
        let item2 = makeItem(id: UUID(), description: "A description", location: "A location", imageURL: URL(string: "http://www.another-utl.com")!)
        let items = [item1.model,item2.model]
        
        expect(sut, toCompleteWithResult: .success(items), when: {
            let jsonData: Data = makeItemsJson([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: jsonData)
        })
        
    }
    
    
    // MARK:- Test Helper
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location:  String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        let json: [String: Any] = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString,
            ].reduce(into: [String: Any]()){acc, e in
                if let value = e.value {acc[e.key] = value}
        }
        return(item,json)
    }
    
    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        let itemsJSON = ["items": items]
        return try! JSONSerialization.data(withJSONObject: itemsJSON)
    }
    
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult result: RemoteFeedLoader.Result, when action:() -> Void, file: StaticString = #file, line: UInt = #line){
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load {capturedResults.append($0)}
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient{
        
        private var messages = [(url: URL, completion: ((HTTPClientResult) -> Void))]()
        var requestedURLs: [URL] {
            return messages.map{$0.url}
        }
        
        func get(from url: URL,  completion: @escaping ((HTTPClientResult) -> Void)){
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code : Int, data: Data = Data(), at index: Int = 0){
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
