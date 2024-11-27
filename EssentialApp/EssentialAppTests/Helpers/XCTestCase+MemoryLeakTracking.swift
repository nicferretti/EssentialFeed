//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2024/11/27.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocted. Potential memory leak.", file: file, line: line)
        }
    }
}
