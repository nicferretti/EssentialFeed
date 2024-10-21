//
//  UITableView+Dequeueing.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/10/02.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
