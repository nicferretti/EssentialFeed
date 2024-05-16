//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/15.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClientTests: XCTestCase {

    override func setUp() {
        super.setUp()

        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let expectation = expectation(description: "Wait for request")
        let url = anyURL
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")

            expectation.fulfill()
        }

        makeSUT().get(from: url) { _ in }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError
        let receivedError = resultError(data: nil, response: nil, error: requestError) as NSError?

        XCTAssertEqual(requestError.domain, receivedError?.domain)
        XCTAssertEqual(requestError.code, receivedError?.code)
    }

    func test_getFromURL_failsOnAllNilValues() {
        XCTAssertNotNil(resultError(data: nil, response: nil, error: nil))
    }

    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultError(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultError(data: nil, response: nonHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultError(data: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultError(data: anyData, response: nil, error: anyNSError))
        XCTAssertNotNil(resultError(data: nil, response: nonHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(data: nil, response: anyHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(data: anyData, response: nonHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(data: anyData, response: anyHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(data: anyData, response: nonHTTPURLResponse, error: nil))
    }

    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData
        let response = anyHTTPURLResponse
        
        let receivedValues = resultValuesFor(data: data, response: response, error: nil)

        let receivedData = receivedValues?.data
        let receivedResponse = receivedValues?.response

        XCTAssertEqual(receivedData, data)
        XCTAssertEqual(receivedResponse?.url, response.url)
        XCTAssertEqual(receivedResponse?.statusCode, response.statusCode)
    }

    func test_getFromURL_succeedsWithEmptyDataHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse
        let receivedValues = resultValuesFor(data: nil, response: response, error: nil)

        let receivedData = receivedValues?.data
        let receivedResponse = receivedValues?.response

        let emptyData = Data()
        XCTAssertEqual(receivedData, emptyData)
        XCTAssertEqual(receivedResponse?.url, response.url)
        XCTAssertEqual(receivedResponse?.statusCode, response.statusCode)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()

        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }

    private func resultError(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .failure(error):
            return error

        default:
            XCTFail("Expected failure, but got \(result) instead.", file: file, line: line)
            return nil
        }
    }

    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .success(data, response):
            return (data, response)

        default:
            XCTFail("Expected success, but got \(result) instead.", file: file, line: line)
            return nil
        }
    }

    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClientResult {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)

        let expectation = expectation(description: "Wait for completion")

        var receivedResult: HTTPClientResult!
        sut.get(from: anyURL) { result in
            receivedResult = result

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        return receivedResult
    }

    var anyURL: URL {
        return URL(string: "https://some-url.com")!
    }

    var nonHTTPURLResponse: URLResponse {
        return URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

    var anyHTTPURLResponse: HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    let anyData = Data("any data".utf8)
    let anyNSError = NSError(domain: "any error", code: 0)

    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?

        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }

        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }

        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let _ = request.url, let stub = URLProtocolStub.stub else { return }

            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {

        }
    }

}
