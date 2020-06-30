//
//  SlideViewController.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 29.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

fileprivate let MENU_WIDTH: CGFloat = 300

class SlideViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupControllers()
        setapPanGesture()
    }
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var leadingContentConstraint: NSLayoutConstraint = {
        let constraint = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        return constraint
    }()
    fileprivate var menuIsOpen = false
    fileprivate lazy var darkCoverView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false //Позволяет отработать жестам на уровеьн ниже
        return view
    }()
}

fileprivate extension SlideViewController {
    func setupUI() {
        view.addSubview(contentView)
        view.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leadingContentConstraint,
            
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            menuView.widthAnchor.constraint(equalToConstant: MENU_WIDTH),

        ])
        
    }
    
    func setupControllers() {
        let menuViewController = MenuViewController()
        let homeViewController = HomeViewController()
        
        guard let menuVCView = menuViewController.view, let homeVCView = homeViewController.view else { return }
        
        contentView.addSubview(homeVCView)
        homeVCView.translatesAutoresizingMaskIntoConstraints = false
        
        menuView.addSubview(menuVCView)
        menuVCView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(darkCoverView)
        
        NSLayoutConstraint.activate([
            homeVCView.topAnchor.constraint(equalTo: contentView.topAnchor),
            homeVCView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            homeVCView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            homeVCView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            menuVCView.topAnchor.constraint(equalTo: menuView.topAnchor),
            menuVCView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor),
            menuVCView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            menuVCView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            
            darkCoverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
        addChild(menuViewController)
        addChild(homeViewController)
        
    }
    
    func setapPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        view.addGestureRecognizer(panGesture)
        
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
    }
    
    @objc
    func panHandle(_ sender: UIPanGestureRecognizer) {
        
        var tx = sender.translation(in: view).x
        tx = menuIsOpen ? tx + MENU_WIDTH : tx
    
        //min(menuWidth, tx) запретит выдвигать меню вправо
        //max - запретит выезжать влево
        
        tx = max(0, min(MENU_WIDTH, tx))
        leadingContentConstraint.constant = tx
        
        //tx - прогресс | menuWidth - общая шкала
        darkCoverView.alpha = tx / MENU_WIDTH
        
        if case .ended = sender.state {
            handleEnded(sender)
        }
    }
    
    func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let velocity = abs(gesture.velocity(in: view).x)
        let treshold : CGFloat = 450
        
        if menuIsOpen {
            velocity > treshold ? closeMenu() : openMenu()
        } else {
            velocity > treshold ? openMenu() : closeMenu()
        }
        
    }
    
    func performAnimations() {
        let alphaFlag = menuIsOpen
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        self?.darkCoverView.alpha = alphaFlag ? 1 : 0
        })
    }
    
    func openMenu() {
        leadingContentConstraint.constant = MENU_WIDTH
        menuIsOpen = true
        performAnimations()
    }
    
    func closeMenu() {
        leadingContentConstraint.constant = 0
        menuIsOpen = false
        performAnimations()
    }
}

