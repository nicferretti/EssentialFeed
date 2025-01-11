//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2025/01/11.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
    private init() {}

    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>

    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
        let presentationAdapter = CommentsPresentationAdapter(loader: { commentsLoader().dispatchOnMainQueue() })

        let commentsViewController = makeCommentsViewControllerWith(title: ImageCommentsPresenter.title)
        commentsViewController.onRefresh = presentationAdapter.loadResource

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentsViewAdapter(controller: commentsViewController),
            loadingView: WeakRefVirtualProxy(commentsViewController),
            errorView: WeakRefVirtualProxy(commentsViewController),
            mapper: { ImageCommentsPresenter.map($0) })

        return commentsViewController
    }

    private static func makeCommentsViewControllerWith(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.title = title

        return controller
    }
}

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}
