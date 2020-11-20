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
    private let currentDate: () -> Date
    var store: FeedStore
    init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func saveItems(_ items: [FeedItem]){
        store.deleteCachedFeed {[unowned self] error in
            if error == nil {
                self.store.insert(items, timeStamp: currentDate())
            }
        }
    }
}
class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    var deletedCacheFeedCallCount = 0;
    var insertions: [(items: [FeedItem], timeStamp: Date)] = []
    private var deletionCompletions: [DeletionCompletion] = []
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletedCacheFeedCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func insert(_ items: [FeedItem], timeStamp: Date) {
        insertions.append((items, timeStamp))
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
        
        XCTAssertEqual(store.insertions.count, 0)
    }
    
    func test_save_requestNewCacheInsertionWithTimeStampOnSuccessfulCacheDeletion() {
        let timeStamp = Date()
        let (sut, store) = makeSUT(currentDate: {timeStamp})
        let items = [uniqueItem(), uniqueItem(), uniqueItem()]
        
        sut.saveItems(items)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertions.count, 1)
        XCTAssertEqual(store.insertions.first?.items, items)
        XCTAssertEqual(store.insertions.first?.timeStamp, timeStamp)
    }
    
    //MARK:- Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
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
