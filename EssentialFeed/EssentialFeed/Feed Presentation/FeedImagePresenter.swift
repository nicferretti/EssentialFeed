//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/02.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
                    description: image.description,
                    location: image.location)
    }
}
