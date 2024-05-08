//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/08.
//

import Foundation

public final class RemoteFeedLoader {

    private let url: URL
    private let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() {
        client.get(from: url)
    }
}

public protocol HTTPClient {
    func get(from url: URL)
}