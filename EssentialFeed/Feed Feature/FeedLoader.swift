//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error

    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
