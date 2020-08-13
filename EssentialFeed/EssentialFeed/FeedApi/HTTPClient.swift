//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 13/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient{
    func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void))
}
