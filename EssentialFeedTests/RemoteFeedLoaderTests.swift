//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import XCTest

class RemoteFeedLoader {

}

class HTTPClient {
    var requestedUrl: URL?
}

class RemoteFeedLoaderTests: XCTest {

    func test_init_doesNotRequestsDataFromURL() {
        let client = HTTPClient()

        _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedUrl)
    }
}
