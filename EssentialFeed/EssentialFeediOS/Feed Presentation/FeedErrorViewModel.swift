//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 27/02/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

struct FeedErrorViewModel {
     let message: String?
    
    static var noError: FeedErrorViewModel {
         return FeedErrorViewModel(message: nil)
     }

     static func error(message: String) -> FeedErrorViewModel {
         return FeedErrorViewModel(message: message)
     }
 }
