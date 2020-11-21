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
    
    public init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func saveItems(_ items: [FeedItem], completion: @escaping(Error?) -> Void){
        store.deleteCachedFeed {[weak self] error in
            guard let self = self else {return}
            if let cachedeletionError = error {
                completion(cachedeletionError)
            }
            else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with conpletion: @escaping (Error?) -> Void) {
        store.insert(items, timeStamp: currentDate()) { [weak self] error in
            guard self != nil else {return}
            conpletion(error)
        }
    }
}
