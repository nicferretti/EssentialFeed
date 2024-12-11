//
//  FeedItemsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import XCTest
import EssentialFeed

class FeedItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let sampleStatusCodes = [199, 201, 300, 400, 500]

        try sampleStatusCodes.forEach { statusCode in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: statusCode))
            )
        }

    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("Invalid json".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])

        let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONList() throws {
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "https://a-url.com")!)

        let item2 = makeItem(
            id: UUID(),
            description: "Some description",
            location: "Some location",
            imageURL: URL(string: "https://another-url.com")!)

        let items = [item1.model, item2.model]
        let json = makeItemsJSON([item1.json, item2.json])

        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, items)
    }

    // MARK: - Helpers

    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)
        let jsonItem = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ].compactMapValues { $0 }

        return (item, jsonItem)
    }
}
