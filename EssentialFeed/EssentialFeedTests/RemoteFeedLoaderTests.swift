//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

class RemoteFeedLoader{
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(){
        client.get(from: URL(string: "http://a-url.com")!)
    }
}

protocol HTTPClient{
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient{
    func get(from url: URL){
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doestNotRequestDataFromUrl(){
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromUrl(){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
