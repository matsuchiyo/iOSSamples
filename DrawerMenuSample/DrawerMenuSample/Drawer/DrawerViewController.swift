//
//  DrawerViewController.swift
//  DrawerMenuSample
//
//  Created by 松島勇貴 on 2020/04/14.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .currentContext
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
}

extension DrawerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerPresentedAnimatedTransitioning()
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DrawerPresentedAnimatedTransitioning()
//    }
}
