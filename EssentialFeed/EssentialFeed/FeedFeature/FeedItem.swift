//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 31/07/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation
public struct FeedImage: Hashable{
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}

