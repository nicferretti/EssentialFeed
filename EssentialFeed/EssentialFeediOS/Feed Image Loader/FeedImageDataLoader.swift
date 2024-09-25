//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Nicholas Ferretti on 2024/09/25.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
