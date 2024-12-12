//
//  SharedLocalizationStrings.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/12.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {
            
        }
    }
}
