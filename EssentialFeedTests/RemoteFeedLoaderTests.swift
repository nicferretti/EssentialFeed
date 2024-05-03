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
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
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
        let url = URL(string: "https://some-url.com")!
        let client = HTTPClientSpy()

        _ = RemoteFeedLoader(url: url, client: client)

        XCTAssertNil(client.requestedUrl)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://some-give-url.com")!
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(url: url, client: client)

        sut.load()

        XCTAssertEqual(client.requestedUrl, url)
    }
}
