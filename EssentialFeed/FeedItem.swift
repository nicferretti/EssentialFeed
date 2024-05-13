//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/03.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
