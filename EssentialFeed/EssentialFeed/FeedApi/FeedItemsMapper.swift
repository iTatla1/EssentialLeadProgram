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
        let items: [Item]
        
        var feed: [FeedItem]{
            items.map{$0.item}
        }
    }
    
    private struct Item: Decodable{
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
            else { return .failure(.invalidData)}
        return (.success(root.feed))
        
    }
}






