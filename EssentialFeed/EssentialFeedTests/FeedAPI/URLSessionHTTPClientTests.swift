//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 14/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
    
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient{
    private let session: HTTPSession
    
    init(session: HTTPSession){
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void){
        session.dataTask(with: url){_,_,error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskFromURL(){
        let url = URL(string: "http://www.a-url.com")!
        let session = HTTPSessionSpy()
        let task = HTTPSessionTaskTaskSpy()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url){_ in}
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    
    func test_getFormUrl_failsOnRequestError(){
        
        let url = URL(string: "http://www.a-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "any-error", code: 1)
        session.stub(url: url, error: error)
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url){result in
            switch result{
            case .failure(let error as NSError):
                XCTAssertEqual(error, error)
            default:
                XCTFail("Expected failure with \(error) got result \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    //MARK:- Helper
    private class HTTPSessionSpy: HTTPSession {
        private var stubs: [URL: Stub] = [:]
        
        private struct Stub {
            let task: HTTPSessionTask
            let error: Error?
        }
        
        func stub(url: URL, task: HTTPSessionTask = HTTPSessionTaskTaskSpy(), error: Error? = nil){
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url] else{
                fatalError("Could not find stub for \(url)")
            }
            completionHandler(nil,nil,stub.error)
            return stub.task
        }
        
    }

    
    private class HTTPSessionTaskTaskSpy: HTTPSessionTask{
        var resumeCallCount: Int = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}

