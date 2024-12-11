//
//  ImageComment.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/11.
//

public struct ImageComment: Equatable {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let username: String

    public init( id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.username = username
    }
}
