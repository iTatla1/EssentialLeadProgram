//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 31/07/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
