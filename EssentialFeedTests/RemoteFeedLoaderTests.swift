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

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://some-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedUrls = [URL]()

        func get(from url: URL) {
            requestedUrls.append(url)
        }
    }
}
