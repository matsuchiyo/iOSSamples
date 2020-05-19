//
//  DrawerPresentedAnimatedTransitioning.swift
//  DrawerMenuSample
//
//  Created by 松島勇貴 on 2020/04/14.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class DrawerPresentedAnimatedTransitioning: NSObject {
}

extension DrawerPresentedAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let contentView = transitionContext.view(forKey: .from),
            let drawerView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let drawerWidth = UIScreen.main.bounds.width * 0.8
        let startFrame = CGRect(x: -drawerWidth, y: 0, width: drawerWidth, height: contentView.frame.height)
        drawerView.frame = startFrame
        containerView.addSubview(drawerView)
        
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        let delay: TimeInterval = 0
        let options: UIView.AnimationOptions = .curveEaseOut
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            drawerView.frame = CGRect(x: 0, y: 0, width: drawerWidth, height: contentView.frame.height)
            contentView.frame = CGRect(x: drawerWidth, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            
        }, completion: { finished in
            guard finished else {
                transitionContext.completeTransition(false)
                return
            }
            
            transitionContext.completeTransition(true)
        })
    }
}
