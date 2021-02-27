//
//  FeddPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 27/02/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

final class FeedPresnter {
    init(view: Any) {}
}

class FeddPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresnter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresnter(view: view)
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return(sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
