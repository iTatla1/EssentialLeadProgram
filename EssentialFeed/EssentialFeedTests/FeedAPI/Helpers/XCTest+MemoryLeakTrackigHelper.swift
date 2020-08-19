//
//  XCTest+MemoryLeakTrackigHelper.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 19/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject,  file: StaticString = #file, line: UInt = #line){
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been de allocated. Potential memory leak!!", file: file, line: line)
        }
    }
}
