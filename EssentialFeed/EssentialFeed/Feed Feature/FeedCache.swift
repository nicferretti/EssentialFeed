//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/02.
//

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
