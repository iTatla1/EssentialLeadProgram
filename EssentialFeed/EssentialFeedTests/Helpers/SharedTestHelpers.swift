//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 23/11/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import Foundation

func anyURL() -> URL{
    return URL(string: "http://www.a-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any-error", code: 33, userInfo: nil)
}
