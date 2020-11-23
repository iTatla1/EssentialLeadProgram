//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 31/07/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedImage])
    case failure(Error)
}


public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
