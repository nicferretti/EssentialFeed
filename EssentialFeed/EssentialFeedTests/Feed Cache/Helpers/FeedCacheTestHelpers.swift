//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/07/11.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL)
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let imageFeed = [uniqueImage(), uniqueImage()]
    let localImageFeed = imageFeed.map{ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}

    return (imageFeed, localImageFeed)
}

extension Date {
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }

    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
}
