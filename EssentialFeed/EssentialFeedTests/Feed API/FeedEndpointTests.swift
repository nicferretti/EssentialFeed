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

        let receivedURL = FeedEnpoint.get.url(baseURL: baseURL)
        let expectedURL = URL(string: "https://base-url.com/v1/feed")!

        XCTAssertEqual(receivedURL, expectedURL)
    }
}
