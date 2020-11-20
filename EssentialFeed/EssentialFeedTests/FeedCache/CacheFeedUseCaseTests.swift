//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 20/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    var store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
    
    func saveItems(_ items: [FeedItem]){
        store.deleteCachedFeed()
    }
}
class FeedStore {
    var deletedCacheFeedCallCount = 0;
    
    func deleteCachedFeed() {
        deletedCacheFeedCallCount += 1
    }
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation(){
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deletedCacheFeedCallCount, 0)
    }

    func test_save_requestCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        let items = [uniqueItem(), uniqueItem(), uniqueItem()]
        sut.saveItems(items)
        
        XCTAssertEqual(store.deletedCacheFeedCallCount, 1)
    }
    
    //MARK:- Helpers
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL{
        return URL(string: "http://www.a-url.com")!
    }
}
