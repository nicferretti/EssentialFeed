//
//  RemoteLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/12/11.
//

import XCTest
import EssentialFeed

final class RemoteLoaderTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://some-give-url.com")!

        let (sut, client) = makeSUT(url: url)

        sut.load { _ in}

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://some-give-url.com")!

        let (sut, client) = makeSUT(url: url)

        sut.load { _ in}
        sut.load { _ in}

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        // Create list of sample error codes
        // Create code just before, just after and then a few other cases
        let sampleStatusCodes = [199, 201, 300, 400, 500]
        sampleStatusCodes.enumerated().forEach { index, statusCode in
            expect(sut, toCompleteWithResult: failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: statusCode, data: json, at: index)
            })
        }

    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .failure(RemoteLoader.Error.invalidData), when: {
            let invalidJSON = Data("Invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()

        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "https://a-url.com")!)

        let item2 = makeItem(
            id: UUID(),
            description: "Some description",
            location: "Some location",
            imageURL: URL(string: "https://another-url.com")!)

        let items = [item1.model, item2.model]

        expect(sut, toCompleteWithResult: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://some-url.com")!
        let client = HTTPClientSpy()

        var sut: RemoteLoader? = RemoteLoader(url: url, client: client)

        var capturedResults = [RemoteLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil

        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://some-url.com")!) -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(url: url, client: client)

        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)

        return (sut, client)
    }

    private func failure(_ error: RemoteLoader.Error) -> RemoteLoader.Result {
        return .failure(error)
    }

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

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = [ "items": items ]

        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: RemoteLoader, toCompleteWithResult expectedResult: RemoteLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {

        let expectation = expectation(description: "Wait for load to complete")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as RemoteLoader.Error), .failure(expectedError as RemoteLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead.", file: file, line: line)
            }

            expectation.fulfill()
        }

        action()

        wait(for: [expectation], timeout: 1.0)
    }

}
