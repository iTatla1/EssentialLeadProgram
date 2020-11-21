//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 13/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

internal final class FeedItemsMapper {
    private static var OK_200: Int{return 200}
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
            else { throw RemoteFeedLoader.Error.invalidData}
        return root.items
        
    }
}
