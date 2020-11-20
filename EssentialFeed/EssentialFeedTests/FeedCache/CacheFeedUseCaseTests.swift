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
        store.deleteCachedFeed {[unowned self] error in
            if error == nil {
                self.store.insert(items)
            }
        }
    }
}
class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    var deletedCacheFeedCallCount = 0;
    var insertCallCount = 0
    private var deletionCompletions: [DeletionCompletion] = []
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletedCacheFeedCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func insert(_ items: [FeedItem]) {
        insertCallCount += 1
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation(){
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deletedCacheFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        
        let items = [uniqueItem(), uniqueItem(), uniqueItem()]
        sut.saveItems(items)
        
        XCTAssertEqual(store.deletedCacheFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem(), uniqueItem()]
        
        let deletionError = anyNSError()
        sut.saveItems(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem(), uniqueItem()]
        
        sut.saveItems(items)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertCallCount, 1)
    }
    
    //MARK:- Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeak(store, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return(sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL{
        return URL(string: "http://www.a-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any-error", code: 33, userInfo: nil)
    }
}
