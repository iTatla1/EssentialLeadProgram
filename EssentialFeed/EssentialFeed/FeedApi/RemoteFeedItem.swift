//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 21/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

internal struct RemoteFeedItem: Decodable{
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
