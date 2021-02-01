//
//  UITableView+DequeueHelper.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 01/02/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

