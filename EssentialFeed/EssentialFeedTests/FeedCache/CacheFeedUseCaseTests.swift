//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 20/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}
class FeedStore {
    var deletedCacheFeedCallCount = 0;
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation(){
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deletedCacheFeedCallCount, 0)
    }

}
