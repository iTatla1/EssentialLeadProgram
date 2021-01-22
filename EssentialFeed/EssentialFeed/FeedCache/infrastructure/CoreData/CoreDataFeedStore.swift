//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 12/12/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import CoreData

public class CoreDataFeedStore: FeedStore {
    private let contatiner: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        contatiner = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = contatiner.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map{
                    return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                managedCache.timestamp = timeStamp
                try context.save()
            })
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform {
            action(context)
        }
    }
}
