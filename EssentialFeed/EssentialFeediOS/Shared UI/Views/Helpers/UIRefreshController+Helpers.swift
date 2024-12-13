//
//  UIRefreshCOntroler+Helpers.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/21.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
