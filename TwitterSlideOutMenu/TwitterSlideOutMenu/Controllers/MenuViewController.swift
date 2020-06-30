//
//  MenuViewController.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 26.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

struct CellItem {
    var icon: UIImage?
    let title: String
}

final class MenuViewController: UITableViewController {
    
    let cellItems : [CellItem] = [
        CellItem(icon: UIImage(systemName: "person"), title: "Home"),
        CellItem(icon: UIImage(systemName: "list.number"), title: "Lists"),
        CellItem(icon: UIImage(systemName: "bookmark"), title: "Bookmarks"),
        CellItem(icon: UIImage(systemName: "bolt"), title: "Moments")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = .none
    }
    
    fileprivate let headerView = MenuHeaderView()
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell(style: .default, reuseIdentifier: "MenuItemCell")
        cell.item = cellItems[indexPath.row]
        return cell
    }
    
}

