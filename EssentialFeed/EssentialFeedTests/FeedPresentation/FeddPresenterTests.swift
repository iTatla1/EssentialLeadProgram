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
        let view = ViewSpy()
        _ = FeedPresnter(view: view)
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }
}
