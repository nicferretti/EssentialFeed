//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/09/26.
//

import UIKit
import EssentialFeed

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageViewCell?

    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate

    }

    func view(in tableView: UITableView) -> UITableViewCell {
        self.cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }

    func preload() {
        delegate.didRequestImage()
    }

    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }

    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.feedImageView.setImageAnimated(viewModel.image)
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
        cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
