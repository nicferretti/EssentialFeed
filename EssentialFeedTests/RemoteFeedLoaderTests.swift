//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {

    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        client.get(from: URL(string: "https://some-url.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL) 
}

class HTTPClientSpy: HTTPClient {
    var requestedUrl: URL?

    func get(from url: URL) {
        requestedUrl = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let client = HTTPClientSpy()

        _ = RemoteFeedLoader(client: client)

        XCTAssertNil(client.requestedUrl)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedUrl)
    }
}
