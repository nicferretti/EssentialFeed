//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2025/01/12.
//

public enum FeedEnpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
