//
//  FeedViewController.swift
//  Prototype
//
//  Created by Muhammad Usman Tatla on 02/01/2021.
//

import UIKit
struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}
final class FeedViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedImageViewModel.prototypeFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") ?? UITableViewCell()
    }
}
