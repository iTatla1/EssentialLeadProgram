//
//  FeddPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 27/02/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

struct FeedErrorViewModel {
     let message: String?
    
    static var noError: FeedErrorViewModel {
         return FeedErrorViewModel(message: nil)
     }
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresnter {
    private let errorView: FeedErrorView
    
    init(errorView: FeedErrorView) {
        self.errorView = errorView
    }
    
    func didStartLoading() {
        errorView.display(.noError)
    }
}

class FeddPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displayNoErrorMessage(){
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresnter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresnter(errorView: view)
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return(sut, view)
    }
    
    private class ViewSpy: FeedErrorView {
        
        enum Message: Equatable {
            case display(errorMessage: String?)
        }
        
        private(set) var messages = [Message]()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
    }
}
