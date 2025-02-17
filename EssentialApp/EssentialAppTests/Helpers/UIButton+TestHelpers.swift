//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/21.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
