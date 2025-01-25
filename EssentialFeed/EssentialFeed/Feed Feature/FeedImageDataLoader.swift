//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Nicholas Ferretti on 2024/09/25.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
