//
//  FeedUIIntegrationTests+Assertions.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/21.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedImageViews() == feed.count else {
            return XCTFail("Expcted \(feed.count) images, got \(sut.numberOfRenderedImageViews()) instead", file: file, line: line)
        }

        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        guard let cell = view as? FeedImageViewCell else {
            return XCTFail("Expected \(FeedImageViewCell.self) instance, got \(String(describing: view)) instead.", file: file, line: line)
        }

        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index \(index).", file: file, line: line)

        XCTAssertEqual(cell.locationText, image.location, "Expected location to be \(String(describing: image.location)) for image view at index \(index).", file: file, line: line)

        XCTAssertEqual(cell.descriptionText, image.description, "Expected description to be \(String(describing: image.description)) for image view at index \(index).", file: file, line: line)
    }
}
