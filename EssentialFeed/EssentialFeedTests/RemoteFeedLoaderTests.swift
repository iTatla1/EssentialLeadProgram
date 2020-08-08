//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

class RemoteFeedLoader{
    
}

class HTTPClient{
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_doestNotRequestDataFromUrl(){
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }

}
