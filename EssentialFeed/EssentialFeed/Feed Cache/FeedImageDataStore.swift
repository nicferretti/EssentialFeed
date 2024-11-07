//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/11/07.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
