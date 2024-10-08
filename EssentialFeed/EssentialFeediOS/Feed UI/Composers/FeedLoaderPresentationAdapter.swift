//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/08.
//

import EssentialFeed
import UIKit

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {

    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
