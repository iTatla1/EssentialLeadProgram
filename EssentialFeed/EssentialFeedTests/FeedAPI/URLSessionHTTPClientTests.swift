//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 14/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest

class URLSessionHTTPClient{
    private let session: URLSession
    
    init(session: URLSession){
        self.session = session
    }
    
    func get(from url: URL){
        session.dataTask(with: url, completionHandler: {_,_,_ in})
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_createsDataTaskFromURL(){
        let url = URL(string: "http://www.a-url.com")!
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLS, [url])
    }
    
    
    //MARK:- Helper
    private class URLSessionSpy: URLSession {
        var receivedURLS: [URL] = []
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLS.append(url)
            
            return FakeURLSessionDataTask()
        }
        
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask{}
}

