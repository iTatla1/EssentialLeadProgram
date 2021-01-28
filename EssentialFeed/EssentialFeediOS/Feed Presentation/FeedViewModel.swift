//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 27/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//
import EssentialFeed

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChane: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    func loadFeed() {
        onLoadingStateChane?(true)
        feedLoader.load{[weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChane?(false)
        }
    }
}
