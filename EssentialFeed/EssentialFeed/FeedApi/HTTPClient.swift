//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 13/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

public protocol HTTPClient{
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, completion: @escaping ((Result) -> Void))
}
