//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/02.
//

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
