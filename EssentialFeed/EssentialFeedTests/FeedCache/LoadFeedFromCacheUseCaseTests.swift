//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 22/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreCreation(){
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestcacheRetrival(){
        let (sut, store) = makeSUT()
        
        sut.load() {_ in}
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        let retrievalError = anyNSError()
        
        var receivedErrors: [Error?] = []
        sut.load { result in
            switch result {
            case let .failure(error):
                receivedErrors.append(error)
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(receivedErrors as? [NSError], [retrievalError])
    }

    //MARK:- Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return(sut, store)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any-error", code: 33, userInfo: nil)
    }
    
    
}
