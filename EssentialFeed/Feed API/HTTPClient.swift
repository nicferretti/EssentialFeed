//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/05/14.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
