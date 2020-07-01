//
//  ViewController.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 25.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        setupNavigationItem()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .white
        cell.textLabel?.text = "Test"
        return cell
    }
    
}

fileprivate extension HomeViewController {
    
    func setupNavigationItem() {
        title = "Home"
        let image = UIImage(named: "GitHub_avatar")?.withRenderingMode(.alwaysOriginal)
        let imageButton = UIButton()
        imageButton.setImage(image, for: .normal)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.imageView?.layer.cornerRadius = 20
        imageButton.clipsToBounds = true
        imageButton.adjustsImageWhenHighlighted = false
        imageButton.addTarget(self, action: #selector(openHandle), for: .touchDown)
        let buttonItem = UIBarButtonItem(customView: imageButton)
        
        navigationItem.leftBarButtonItem = buttonItem
    }
    
    @objc
    func openHandle() {
        guard let parent = navigationController?.parent as? SlideViewController else { return }
        parent.openMenu()
        
    }
 
}

