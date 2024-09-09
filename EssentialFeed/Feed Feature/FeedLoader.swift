//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
