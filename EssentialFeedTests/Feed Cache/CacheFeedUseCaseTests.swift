//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/06/26.
//

import XCTest
import EssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()

        let (imageFeed, _) = uniqueImageFeed()
        sut.save(imageFeed) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }

    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()

        let (imageFeed, _) = uniqueImageFeed()
        sut.save(imageFeed) { _ in }

        let deletionError = anyNSError
        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }

    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })

        let (imageFeed, localImageFeed) = uniqueImageFeed()
        sut.save(imageFeed) { _ in }

        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(localImageFeed, timestamp)])
    }

    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()

        let deletionError = anyNSError
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()

        let insertionError = anyNSError
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_doeNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalFeedLoader.SaveResult]()
        let (imageFeed, _) = uniqueImageFeed()
        sut?.save(imageFeed) { receivedResults.append($0) }
        store.completeDeletionSuccessfully()

        sut = nil

        store.completeInsertion(with: anyNSError)

        XCTAssertTrue(receivedResults.isEmpty)
    }

    func test_save_doeNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalFeedLoader.SaveResult]()
        let (imageFeed, _) = uniqueImageFeed()
        sut?.save(imageFeed) { receivedResults.append($0) }

        sut = nil

        store.completeDeletion(with: anyNSError)

        XCTAssertTrue(receivedResults.isEmpty)
    }


    // MARK: - Helpers

    var anyURL: URL {
        return URL(string: "https://some-url.com")!
    }

    let anyNSError = NSError(domain: "any error", code: 0)

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let (imageFeed, _) = uniqueImageFeed()
        let expectation = expectation(description: "Wait for save completion")
        var receivedError: Error?
        sut.save(imageFeed) { error in
            receivedError = error
            expectation.fulfill()
        }

        action()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, expectedError)
    }

    private func uniqueImage() -> FeedImage {
        return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL)
    }

    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let imageFeed = [uniqueImage(), uniqueImage()]
        let localImageFeed = imageFeed.map{ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}

        return (imageFeed, localImageFeed)
    }

}
