//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 31/07/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error>{
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable{}



protocol FeedLoader {
    associatedtype Error: Swift.Error
    func loadItems(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
