//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://some-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()

    func get(from url: URL) {

    }
}

class HTTPClientSpy: HTTPClient {
    var requestedUrl: URL?

    override func get(from url: URL) {
        requestedUrl = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let client = HTTPClientSpy()

        _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedUrl)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader()

        sut.load()

        XCTAssertNotNil(client.requestedUrl)
    }
}
