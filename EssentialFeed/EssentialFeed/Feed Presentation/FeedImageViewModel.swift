//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/30.
//

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    public var hasLocation: Bool {
        return location != nil
    }
}
