//
//  ImageCommentsEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2025/01/12.
//

import XCTest
import EssentialFeed

final class ImageCommentsEndpointTests: XCTestCase {

    func test_imageComments_endpointURL() {
        let imageID = UUID(uuidString: "2239CBA2-CB35-4392-ADC0-24A37D38E010")!
        let baseURL = URL(string: "https://base-url.com")!

        let received = ImageCommentsEndpoint.get(imageID).url(baseURL: baseURL)
        let expected = URL(string: "https://base-url.com/v1/image/2239CBA2-CB35-4392-ADC0-24A37D38E010/comments")!

        XCTAssertEqual(received, expected)
    }

}
