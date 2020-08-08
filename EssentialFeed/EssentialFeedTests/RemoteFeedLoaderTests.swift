//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

class RemoteFeedLoader{
    func load(){
        HTTPClient.shared.get(from: URL(string: "http://a-url.com")!)
    }
}

class HTTPClient{
    static var shared = HTTPClient()
    func get(from url: URL){}
}

class HTTPClientSpy: HTTPClient{
    override func get(from url: URL){
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doestNotRequestDataFromUrl(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromUrl(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
