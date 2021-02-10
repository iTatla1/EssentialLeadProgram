//
//  UIRefreshController+TestHelper.swift
//  EssentialFeediOSTests
//
//  Created by Muhammad Usman Tatla on 10/02/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh () {
        allTargets.forEach {target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
