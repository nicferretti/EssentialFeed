//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/27.
//

import EssentialFeed

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedViewController = FeedViewController(refreshController: refreshController)

        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedViewController, loader: imageLoader)

        return feedViewController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> (([FeedImage]) -> Void) {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
}
