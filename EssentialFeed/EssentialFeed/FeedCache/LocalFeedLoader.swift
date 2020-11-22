//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 21/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping(SaveResult) -> Void){
        store.deleteCachedFeed {[weak self] error in
            guard let self = self else {return}
            if let cachedeletionError = error {
                completion(cachedeletionError)
            }
            else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void ) {
        store.retrieve { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success([]))
            }
            
        }
    }
    
    private func cache(_ feed: [FeedImage], with conpletion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timeStamp: currentDate()) { [weak self] error in
            guard self != nil else {return}
            conpletion(error)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map{LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}
