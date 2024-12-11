//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/12/11.
//

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
