//
//  FeedImagePresenterTests.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/30.
//

import XCTest
import EssentialFeed

class FeedImagePresenterTests: XCTestCase {

    func test_map_createsViewModel() {
        let image = uniqueImage()

        let viewModel = FeedImagePresenter.map(image)

        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
}
