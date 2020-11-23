//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 21/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public enum RetrievedCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrievedCachedFeedResult) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

