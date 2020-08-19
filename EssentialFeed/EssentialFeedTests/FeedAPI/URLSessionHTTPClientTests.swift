//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Muhammad Usman Tatla on 14/08/2020.
//  Copyright © 2020 Muhammad Usman Tatla. All rights reserved.
//

import XCTest
import EssentialFeed



class URLSessionHTTPClient{
    private let session: URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void){
        let url = URL(string: "http://www.wrong-url.com")!
        session.dataTask(with: url){_,_,error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    
    func test_getFormUrl_failsOnRequestError(){
        URLProtocolStub.startInterceptingRequests()
        
        let url = URL(string: "http://www.a-url.com")!
        let error = NSError(domain: "any-error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url){result in
            switch result{
            case .failure(let receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with \(error) got result \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        URLProtocolStub.endInterceptingRequests()
        
    }
    
    //MARK:- Helper
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        
        private struct Stub {
            let error: Error?
            let data: Data?
            let response: URLResponse?
        }
        
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func endInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        
        static func stub( data: Data?, response: URLResponse?, error: Error?){
            stub = Stub(error: error, data: data, response: response)
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
        
    }
}

