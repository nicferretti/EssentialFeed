//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/26.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    deinit {
        task?.cancel()
    }

    func view() -> UITableViewCell {
        let cell = FeedImageViewCell()
        cell.locationContainer.isHidden = (model.location == nil)
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true

        cell.feedImageContainer.startShimmering()

        let loadImage = { [weak self, weak cell] in
            guard let self else { return }

            self.task = self.imageLoader.loadImageData(from: self.model.url) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil)

                cell?.feedImageContainer.stopShimmering()
            }
        }

        cell.onRetry = loadImage
        loadImage()

        return cell
    }

    func preload() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
}
