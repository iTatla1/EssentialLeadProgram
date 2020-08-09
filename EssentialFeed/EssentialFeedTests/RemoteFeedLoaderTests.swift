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
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromUrlTwice(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliverErrorOnClientError(){
        let (sut, client) = makeSUT()
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load {capturedError.append($0)}
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    // MARK:- Test Helper
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
         let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private class HTTPClientSpy: HTTPClient{
        var requestedURLs: [URL] = []
        var completions: [(Error) -> Void] = []
        func get(from url: URL, completion: @escaping (Error) -> Void){
            completions.append(completion)
            requestedURLs.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0){
            completions[index](error)
        }
    }
}
