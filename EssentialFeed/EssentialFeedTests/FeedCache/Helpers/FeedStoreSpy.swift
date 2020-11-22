//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 22/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
    }
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions: [DeletionCompletion] = []
    private var insertionCompletions: [InsertCompletion] = []
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timeStamp))
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
}
