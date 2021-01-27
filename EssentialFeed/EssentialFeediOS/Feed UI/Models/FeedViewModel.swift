//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 27/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//
import EssentialFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet{onChange?(self)}
    }
    
    func loadFeed() {
        isLoading = true
        feedLoader.load{[weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.isLoading = false
        }
    }
}
