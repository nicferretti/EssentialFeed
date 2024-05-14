//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/14.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]

        var feed: [FeedItem] {
            return items.map{ $0.item }
        }
    }

    struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard 
            response.statusCode == 200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }

        return .success(root.feed)
    }
}
