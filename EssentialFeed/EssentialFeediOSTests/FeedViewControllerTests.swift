//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Muhammad Usman Tatla on 22/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import XCTest
import EssentialFeed
import UIKit

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl?.beginRefreshing()
        
        load()
    }
    
    @objc func load() {
        loader?.load{[weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_intit_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_userIntiatedReload_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserIntiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserIntiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    func test_userIntiatedReload_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.simulateUserIntiatedFeedReload()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_userIntiatedReload_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.simulateUserIntiatedFeedReload()
        loader.completeFeedLoading()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    //MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeak(loader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.insert(completion, at: 0)
        }
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
    }
}

private extension FeedViewController {
    func simulateUserIntiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh () {
        allTargets.forEach {target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
