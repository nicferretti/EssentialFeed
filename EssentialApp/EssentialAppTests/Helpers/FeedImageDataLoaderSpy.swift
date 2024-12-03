//
//  FeedImageDataLoaderSpy.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2024/12/03.
//

import EssentialFeed

class FeedImageDataLoaderSpy: FeedImageDataLoader {
    private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

    private(set) var cancelledURLs = [URL]()

    var loadedURLs: [URL] {
        return messages.map(\.url)
    }

    private struct Task: FeedImageDataLoaderTask {
        let callback: () -> Void

        func cancel() {
            callback()
        }
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        messages.append((url, completion))

        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }

    func complete(with data: Data, at index: Int = 0) {
        messages[index].completion(.success(data))
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
}