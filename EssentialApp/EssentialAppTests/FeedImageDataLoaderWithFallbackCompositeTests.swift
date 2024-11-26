//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2024/11/26.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private class Task: FeedImageDataLoaderTask {
        func cancel() {

        }
    }

    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {

    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
        return Task()
    }
}

class FeedImageDataLoaderWithFallbackCompositeTests: XCTest {
    func test_init_doesNotLoadImageData() {
        
    }

    // MARK: - Helpers

    private class LoaderSpy: FeedImageDataLoader {
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

        var loadedURLs: [URL] {
            return messages.map(\.url)
        }
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {

            }
        }

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
    }
}
