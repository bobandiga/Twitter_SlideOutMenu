//
//  ViewController.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 25.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        setupNavigationItem()
        
        
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(menuViewController.view)
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: window.frame.height)
        addChild(menuViewController)
        
    }
    
    fileprivate var menuWidth: CGFloat = 300
    fileprivate let menuViewController = MenuViewController()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "Test"
        return cell
    }

}

fileprivate extension MainViewController {
    
    func setupNavigationItem() {
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openHandle(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideHandle(_:)))
    }
    
    @objc
    func openHandle(_ sender: UIBarButtonItem) {
        let translationX = menuWidth
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                        self?.menuViewController.view.transform = CGAffineTransform.init(translationX: translationX, y: 0)
                        self?.navigationController?.view.transform = CGAffineTransform.init(translationX: translationX, y: 0)
                        //self?.view.transform = CGAffineTransform.init(translationX: translationX, y: 0)
        }) { (finished) in
            print("Open animation: ", finished)
        }
    }
    
    @objc
    func hideHandle(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: { [weak self] in
                        self?.menuViewController.view.transform = .identity
                        self?.navigationController?.view.transform = .identity
                        //self?.view.transform = .identity
        }) { (finished) in
            print("Dismiss animation: ", finished)
        }
    }
    
}

