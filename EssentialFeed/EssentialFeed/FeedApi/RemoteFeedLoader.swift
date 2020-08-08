//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public protocol HTTPClient{
    func get(from url: URL)
}

public final class RemoteFeedLoader{
    private let url: URL
    private let client: HTTPClient
    
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(){
        client.get(from: url)
    }
}


