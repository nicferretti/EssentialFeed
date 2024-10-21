//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/22.
//

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: .none)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
