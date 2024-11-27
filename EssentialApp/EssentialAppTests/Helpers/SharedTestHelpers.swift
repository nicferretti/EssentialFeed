//
//  SharedTestHelpers.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2024/11/27.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
