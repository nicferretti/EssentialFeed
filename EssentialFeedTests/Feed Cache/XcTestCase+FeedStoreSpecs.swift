//
//  XcTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/08/13.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion to complete")

        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)

        return insertionError
    }

    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion to complete")

        var deletionError: Error?
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)

        return deletionError
    }

    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrievedCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval to complete")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break

            case let (.found(feed: expectedFeed, timestamp: expectedTimeStamp), .found(feed: retrievedFeed, timestamp: retrievedTimestamo)):
                XCTAssertEqual(retrievedFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(retrievedTimestamo, expectedTimeStamp, file: file, line: line)

            default:
                XCTFail("Expected to retrieve \(expectedResult) but got \(retrievedResult) instead", file: file, line: line)

            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrievedCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
}
