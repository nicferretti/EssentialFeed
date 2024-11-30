//
//  FeedLoaderStub.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2024/11/30.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {

    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
