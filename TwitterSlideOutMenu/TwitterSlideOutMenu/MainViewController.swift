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
        setupMenuViewController()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        view.addGestureRecognizer(panGesture)
        
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
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

    
    var menuIsOpen = false
    
}

fileprivate extension MainViewController {
    
    func setupNavigationItem() {
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openHandle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideHandle))
    }
    
    func setupMenuViewController() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(menuViewController.view)
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: window.frame.height)
        addChild(menuViewController)
    }
    
    func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                        self?.menuViewController.view.transform = transform
                        self?.navigationController?.view.transform = transform
        }) { (finished) in
            
        }
    }
    
    @objc
    func openHandle() {
        menuIsOpen = true
        performAnimation(transform: CGAffineTransform.init(translationX: menuWidth, y: 0))
    }
    
    @objc
    func hideHandle() {
        menuIsOpen = false
        performAnimation(transform: .identity)
    }
    
    @objc
    func panHandle(_ sender: UIPanGestureRecognizer) {
        
        var tx = sender.translation(in: view).x
        
        if menuIsOpen {
            tx += menuWidth
        }
        
        //min(menuWidth, tx) запретит выдвигать меню вправо
        //max - запретит выезжать влево
        
        tx = max(0, min(menuWidth, tx))
        
        performAnimation(transform: CGAffineTransform(translationX: tx, y: 0))
        
        if case .ended = sender.state {
            handleEnded(sender)
        }
    }
    
    func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let tx = gesture.translation(in: view).x
        if menuIsOpen {
            if abs(tx) < menuWidth / 4 {
                openHandle()
            } else {
                hideHandle()
            }
        } else {
            if tx < menuWidth / 2 {
                hideHandle()
            } else {
                openHandle()
            }
        }
        
    }
}

