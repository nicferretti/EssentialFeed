//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/27.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}

    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>

    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: { feedLoader().dispatchOnMainQueue() })

        let feedViewController = makeFeedViewControllerWith(delegate: presentationAdapter, title: FeedPresenter.title)

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: feedViewController, imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
            loadingView: WeakRefVirtualProxy(feedViewController),
            errorView: WeakRefVirtualProxy(feedViewController),
            mapper: FeedPresenter.map)

        return feedViewController
    }

    private static func makeFeedViewControllerWith(delegate: FeedViewControllerDelegate, title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyboard.instantiateInitialViewController() as! ListViewController
        feedViewController.title = FeedPresenter.title
        feedViewController.delegate = delegate

        return feedViewController
    }
}




