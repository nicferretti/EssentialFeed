//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/07/10.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
