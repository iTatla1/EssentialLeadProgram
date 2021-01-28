//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 25/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}
final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view: UIRefreshControl = loadView()
    
    private let delegate: FeedRefreshViewControllerDelegate
    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        }
        else {
            view.endRefreshing()
        }
    }
    
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
