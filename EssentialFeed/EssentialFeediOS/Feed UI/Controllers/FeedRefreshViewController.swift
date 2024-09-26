//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/26.
//

import UIKit
import EssentialFeed

public final class FeedRefreshViewController: NSObject {
    public lazy var view: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var onRefresh: (([FeedImage]) -> Void)?

    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }

            self?.view.endRefreshing()
        }
    }
}
