//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/07.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {

        }
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }

    var feedTitle: String {
        FeedPresenter.title
    }

    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
}
