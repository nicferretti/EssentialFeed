//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/08.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
