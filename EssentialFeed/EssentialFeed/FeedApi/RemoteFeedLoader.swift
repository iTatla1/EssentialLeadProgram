//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public protocol HTTPClient{
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader{
    private let url: URL
    private let client: HTTPClient
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (RemoteFeedLoader.Error) -> Void = { _ in}){
        client.get(from: url){_ in completion(.connectivity)}
        
    }
}


