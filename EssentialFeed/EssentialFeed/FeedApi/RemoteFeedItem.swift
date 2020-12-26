//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Muhammad Usman Tatla on 21/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

 struct RemoteFeedItem: Decodable{
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
