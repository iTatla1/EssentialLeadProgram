//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 25/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import UIKit

final class FeedRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = {[weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            }
            else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
