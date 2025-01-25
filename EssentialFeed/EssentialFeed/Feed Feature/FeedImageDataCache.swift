//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/03.
//

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
