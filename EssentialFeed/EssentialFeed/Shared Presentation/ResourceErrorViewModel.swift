//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/22.
//

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: .none)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
