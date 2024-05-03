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
        HTTPClient.shared.requestedUrl = URL(string: "https://some-url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()

    private init() {

    }

    var requestedUrl: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let client = HTTPClient.shared

        _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedUrl)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared

        let sut = RemoteFeedLoader()

        sut.load()

        XCTAssertNotNil(client.requestedUrl)
    }
}
