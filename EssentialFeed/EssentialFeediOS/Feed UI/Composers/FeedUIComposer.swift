//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/27.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))

        let feedViewController = makeFeedViewControllerWith(delegate: presentationAdapter, title: FeedPresenter.title)

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(controller: feedViewController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
            loadingView: WeakRefVirtualProxy(feedViewController),
            errorView: WeakRefVirtualProxy(feedViewController))


        return feedViewController
    }

    private static func makeFeedViewControllerWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedViewController.title = FeedPresenter.title
        feedViewController.delegate = delegate

        return feedViewController
    }
}




