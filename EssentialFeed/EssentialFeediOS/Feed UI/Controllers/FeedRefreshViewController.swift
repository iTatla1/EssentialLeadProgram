//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Muhammad Usman Tatla on 25/01/2021.
//  Copyright © 2021 Muhammad Usman Tatla. All rights reserved.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view: UIRefreshControl = loadView()
    
    private let laodFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.laodFeed = loadFeed
    }
    
    @objc func refresh() {
        laodFeed()
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
