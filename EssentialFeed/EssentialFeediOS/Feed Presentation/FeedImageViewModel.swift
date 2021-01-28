//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 27/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//
import EssentialFeed

struct FeedImageViewModel<Image> {
     let description: String?
     let location: String?
     let image: Image?
     let isLoading: Bool
     let shouldRetry: Bool

     var hasLocation: Bool {
         return location != nil
     }
}
