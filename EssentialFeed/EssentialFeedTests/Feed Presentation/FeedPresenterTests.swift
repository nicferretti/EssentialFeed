//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/10/21.
//

import XCTest
import EssentialFeed

final class FeedPresenterTests: XCTestCase {

    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"))
    }

    func test_map_createsViewModels() {
        let feed = uniqueImageFeed().models

        let viewModel = FeedPresenter.map(feed)

        XCTAssertEqual(viewModel.feed, feed)
    }

    // MARK: - Helpers

    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table: String = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)

        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }

        return value
    }

}
