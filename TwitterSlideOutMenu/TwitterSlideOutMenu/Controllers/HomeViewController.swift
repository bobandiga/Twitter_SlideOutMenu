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
        //setupMenuViewController()
        //setupPanGesture()
        
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(darkCoverView)
        darkCoverView.frame = window.frame
    }
    
    fileprivate lazy var darkCoverView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        //Если установить значение на false то все действия перейдут на иерархию ниже
        view.isUserInteractionEnabled = false
        return view
    }()
    fileprivate var menuWidth: CGFloat = 300
    fileprivate let menuViewController = MenuViewController()
    fileprivate var menuIsOpen = false
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openHandle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideHandle))
    }
    
    func setupMenuViewController() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(menuViewController.view)
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: window.frame.height)
        addChild(menuViewController)
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        view.addGestureRecognizer(panGesture)
        
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
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
                        self?.darkCoverView.transform = transform
                        self?.darkCoverView.alpha = transform == .identity ? 0 : 1
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
        
        //tx - прогресс | menuWidth - общая шкала
        darkCoverView.alpha = tx / menuWidth
        
        performAnimation(transform: CGAffineTransform(translationX: tx, y: 0))
        
        if case .ended = sender.state {
            handleEnded(sender)
        }
    }
    
    func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let velocity = abs(gesture.velocity(in: view).x)
        let treshold : CGFloat = 500
        
        if menuIsOpen {
            velocity > treshold ? hideHandle() : openHandle()
        } else {
            velocity > treshold ? openHandle() : hideHandle()
        }
    }
}

