//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Nicholas Ferretti on 2024/09/16.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var onViewIsAppearing: ((FeedViewController) -> Void)?

    convenience init(loader: FeedLoader) {
        self.init()

        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)

        onViewIsAppearing = { vc in
            vc.load()
            vc.onViewIsAppearing = nil
        }
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        onViewIsAppearing?(self)
    }

    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")

        sut.simulateAppearance()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once the view is loaded")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates another load")
    }

    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expcted loading inidicator once view is loaded")

        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expcted no loading indicator once user initiated loading is completed")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
    }

    class LoaderSpy: FeedLoader {

        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            return completions.count
        }

        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }

        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension FeedViewController {
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            replaceRefreshControlWithFakeForiOS17Support()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()

        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }

        refreshControl = fake
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false

    override var isRefreshing: Bool { _isRefreshing }

    override func beginRefreshing() {
        _isRefreshing = true
    }

    override func endRefreshing() {
        _isRefreshing = false
    }
}
