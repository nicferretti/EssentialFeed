//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/30.
//

import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    var hasLocation: Bool {
        return location != nil
    }
}
