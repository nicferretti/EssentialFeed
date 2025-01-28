//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/11/07.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
