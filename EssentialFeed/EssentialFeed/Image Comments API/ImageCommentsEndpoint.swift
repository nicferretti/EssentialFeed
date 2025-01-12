//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2025/01/12.
//

public enum ImageCommentsEndpoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
