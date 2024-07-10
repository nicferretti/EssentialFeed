//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
