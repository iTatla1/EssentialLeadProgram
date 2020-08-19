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
    
    struct UnexpectedValuesRepresentationError: Error{}
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void){
        session.dataTask(with: url){_,_,error in
            if let error = error {
                completion(.failure(error))
            }
            else{
                completion(.failure(UnexpectedValuesRepresentationError()))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.endInterceptingRequests()
    }
    
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_getFormUrl_failsOnRequestError(){
        let requestError = NSError(domain: "any-error", code: 1)
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        XCTAssertEqual(receivedError as NSError?, requestError)
    }
    
    
    func test_getFormUrl_failsOnAllNilValue(){
       XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
    }
    
    //MARK:- Helper
    
    private func makeSUT( file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient{
        let sut = URLSessionHTTPClient()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func anyURL() -> URL{
        return URL(string: "http://www.a-url.com")!
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: Error?
        sut.get(from: anyURL()){result in
            switch result{
            case .failure(let err):
                receivedError = err
            default:
                XCTFail("Expected failure got result \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest)->Void)?
        
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
            requestObserver = nil
        }
        
        static func observeRequests(observer: @escaping (URLRequest)->Void ){
            requestObserver = observer
        }
        
        static func stub( data: Data?, response: URLResponse?, error: Error?){
            stub = Stub(error: error, data: data, response: response)
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            URLProtocolStub.requestObserver?(request)
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

