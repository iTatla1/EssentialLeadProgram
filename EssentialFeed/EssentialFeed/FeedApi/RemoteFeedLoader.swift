//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 08/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient{
    func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void))
}

public final class RemoteFeedLoader{
    private let url: URL
    private let client: HTTPClient
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (RemoteFeedLoader.Error) -> Void){
        client.get(from: url){ response in
            switch response  {
            case .success( _):
                completion(.invalidData)
            case .failure( _):
                completion(.connectivity)
            }
        }
        
    }
}


