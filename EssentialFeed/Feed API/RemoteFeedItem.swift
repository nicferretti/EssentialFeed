//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/07/10.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
