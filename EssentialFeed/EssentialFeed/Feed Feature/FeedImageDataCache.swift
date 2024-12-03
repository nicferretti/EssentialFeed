//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/03.
//

public protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
