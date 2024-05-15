//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/15.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPSessionDataTask
}

protocol HTTPSessionDataTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession

    init(session: HTTPSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://some-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)

        sut.get(from: url) { _ in }

        XCTAssertEqual(task.resumeCallCount, 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://some-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "Any Error", code: 1)
        session.stub(url: url, error: error)
        let sut = URLSessionHTTPClient(session: session)

        let expectation = expectation(description: "Wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(error, receivedError)

            default:
                XCTFail("Expected failure with error \(error), but got \(result) instead.")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Helpers

    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()

        private struct Stub {
            let task: HTTPSessionDataTask
            let error: Error?
        }

        func stub(url: URL, task: HTTPSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }

    private class FakeURLSessionDataTask: HTTPSessionDataTask {
        func resume() {

        }
    }

    private class URLSessionDataTaskSpy: HTTPSessionDataTask {
        var resumeCallCount = 0

        func resume() {
            resumeCallCount += 1
        }
    }

}
