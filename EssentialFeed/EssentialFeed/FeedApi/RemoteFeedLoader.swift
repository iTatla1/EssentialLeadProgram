//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation



public final class RemoteFeedLoader: FeedLoader{
    
    private let url: URL
    private let client: HTTPClient
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void){
        client.get(from: url){[weak self] response in
            guard self != nil else{return}
            switch response  {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure( _):
                completion(.failure(.connectivity))
            }
        }
        
    }
}

