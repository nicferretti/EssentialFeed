//
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2025/01/12.
//

import XCTest
import EssentialFeed

final class FeedEndpointTests: XCTestCase {

    func test_feed_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!

        let receivedURL = FeedEndpoint.get().url(baseURL: baseURL)

        XCTAssertEqual(receivedURL.scheme, "https", "scheme")
        XCTAssertEqual(receivedURL.host, "base-url.com", "host")
        XCTAssertEqual(receivedURL.path, "/v1/feed", "path")
        XCTAssertEqual(receivedURL.query, "limit=10", "query")
    }

    func test_feed_endpointURLAfterGivenImage() {
        let image = uniqueImage()
        let baseURL = URL(string: "https://base-url.com")!

        let receivedURL = FeedEndpoint.get(after: image).url(baseURL: baseURL)

        XCTAssertEqual(receivedURL.scheme, "https", "scheme")
        XCTAssertEqual(receivedURL.host, "base-url.com", "host")
        XCTAssertEqual(receivedURL.path, "/v1/feed", "path")
        XCTAssertEqual(receivedURL.query?.contains("limit=10"), true, "query")
        XCTAssertEqual(receivedURL.query?.contains("after_id=\(image.id)"), true, "query")
    }
}
