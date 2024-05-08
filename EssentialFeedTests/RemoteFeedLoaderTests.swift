//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedUrls.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://some-give-url.com")!

        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedUrls, [url])
    }

    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://some-give-url.com")!

        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedUrls, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }

        let clientError = NSError(domain: "Test", code: 0)
        client.completions[0](clientError)

        XCTAssertEqual(capturedErrors, [.connectivity])
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://some-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedUrls = [URL]()
        var completions = [(Error) -> Void]()

        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedUrls.append(url)
        }
    }
}
