//
//  UIView+TestHelpers.swift
//  EssentialApp
//
//  Created by Nicholas Ferretti on 2024/12/04.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}
