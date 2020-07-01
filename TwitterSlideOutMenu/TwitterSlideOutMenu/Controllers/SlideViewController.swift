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
        setupMenuViewController()
        setupPanGesture()
        
        setViewController(0)
    }
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate lazy var menuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var leadingContentConstraint: NSLayoutConstraint = {
        let constraint = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        return constraint
    }()
    fileprivate lazy var trailingContentConstraint: NSLayoutConstraint = {
        let constraint = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
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
    
    fileprivate let menuViewController = UINavigationController(rootViewController: MenuViewController())
    fileprivate var contentViewController: UIViewController? {
        didSet {
            setupContentViewController()
        }
    }
    
    
    @objc
    public func setViewController(_ index: Int) {
        switch index {
        case 0:
            let navigationController = UINavigationController(rootViewController: HomeViewController())
            contentViewController = navigationController
            return
        case 1:
            let navigationController = UINavigationController(rootViewController: ListsViewController())
            contentViewController = navigationController
            return
        case 2:
            contentViewController = BookmarksViewController()
        case 3:
            let navigationController = UINavigationController(rootViewController: MomentsViewController())
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers([navigationController], animated: false)
            contentViewController = tabBarController
        default:
            return 
        }
    }
    
    public func openMenu() {
        leadingContentConstraint.constant = MENU_WIDTH
        trailingContentConstraint.constant = MENU_WIDTH
        menuIsOpen = true
        performAnimations()
    }
    
}

fileprivate extension SlideViewController {
    func setupUI() {
        view.addSubview(contentView)
        view.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailingContentConstraint,
            leadingContentConstraint,
            
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor),
            menuView.widthAnchor.constraint(equalToConstant: MENU_WIDTH),
            
        ])
        
        contentView.addSubview(darkCoverView)
        
        NSLayoutConstraint.activate([
            
            darkCoverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
        ])
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissHandle)))
    }
    
    func setupMenuViewController() {
        guard let menuVCView = menuViewController.view else { return }
        
        menuView.addSubview(menuVCView)
        menuVCView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuVCView.topAnchor.constraint(equalTo: menuView.topAnchor),
            menuVCView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor),
            menuVCView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            menuVCView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
        ])
        
        
        addChild(menuViewController)
        
    }
    
    func setupContentViewController() {
        
        contentViewController?.view.removeFromSuperview()
        contentViewController?.removeFromParent()
        
        guard let vc = contentViewController, let view = vc.view else { return  }
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(darkCoverView)
        
        NSLayoutConstraint.activate([
            
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
        ])
        
        contentView.bringSubviewToFront(darkCoverView)
        addChild(vc)
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        view.addGestureRecognizer(panGesture)
        
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
    }
    
    @objc
    func dismissHandle() {
        closeMenu()
    }
    
    @objc
    func panHandle(_ sender: UIPanGestureRecognizer) {
        
        var tx = sender.translation(in: view).x
        tx = menuIsOpen ? tx + MENU_WIDTH : tx
        
        //min(menuWidth, tx) запретит выдвигать меню вправо
        //max - запретит выезжать влево
        
        tx = max(0, min(MENU_WIDTH, tx))
        leadingContentConstraint.constant = tx
        trailingContentConstraint.constant = tx
        
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
    
    
    
    func closeMenu() {
        leadingContentConstraint.constant = 0
        trailingContentConstraint.constant = 0
        menuIsOpen = false
        performAnimations()
    }
}


