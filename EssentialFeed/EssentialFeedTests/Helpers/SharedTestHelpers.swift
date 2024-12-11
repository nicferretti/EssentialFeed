//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Nicholas Ferretti on 2024/07/11.
//

import Foundation

let anyNSError = NSError(domain: "any error", code: 0)

var anyURL: URL {
    return URL(string: "https://some-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = [ "items": items ]

    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
