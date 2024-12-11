//
//  ImageCommentsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/12/11.
//

import XCTest
import EssentialFeed

final class ImageCommentsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJSON([])
        let sampleStatusCodes = [199, 150, 300, 400, 500]

        try sampleStatusCodes.forEach { statusCode in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: statusCode))
            )
        }

    }

    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("Invalid json".utf8)
        let sampleStatusCodes = [200, 201, 250, 280, 299]

        try sampleStatusCodes.forEach { statusCode in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: statusCode))
            )
        }
    }

    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        let sampleStatusCodes = [200, 201, 250, 280, 299]

        try sampleStatusCodes.forEach { statusCode in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: statusCode))

            XCTAssertEqual(result, [])
        }
    }

    func test_map_deliversItemsOn2xxHTTPResponseWithJSONList() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username"
        )

        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            username: "anoter username"
        )

        let items = [item1.model, item2.model]
        let json = makeItemsJSON([item1.json, item2.json])

        let sampleStatusCodes = [200, 201, 250, 280, 299]

        try sampleStatusCodes.forEach { statusCode in

            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: statusCode))

            XCTAssertEqual(result, items)
        }
    }

    // MARK: - Helpers

    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": item.message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ]

        return (item, json)
    }

}
