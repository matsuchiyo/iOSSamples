//
//  PopoverPresentationController.swift
//  PopoverSample
//
//  Created by 松島勇貴 on 2020/05/19.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
//    weak var overlayView: UIView?
    weak var overlayView: UIVisualEffectView?
    
    override func presentationTransitionWillBegin() {
        addOverlayView()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView?.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView?.alpha = 0.0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        overlayView?.removeFromSuperview()
    }

    override func containerViewWillLayoutSubviews() {
        overlayView?.frame = containerView!.bounds
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let childSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        let x = (containerView!.frame.width - childSize.width) / 2
        let y = (containerView!.frame.height - childSize.height) / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: childSize)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let marginLeft: CGFloat = 16
        let childWidth = parentSize.width - marginLeft * 2
        let size = presentedView!.systemLayoutSizeFitting(CGSize(width: childWidth, height: 0))
        return size
    }
    
    override func containerViewDidLayoutSubviews() {
        // do nothing
    }
    
    
    @objc func overlayViewDidTap(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
    
    private func addOverlayView() {
        guard let containerView = containerView else { return }
        
        let overlayView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        overlayView.frame = containerView.bounds
        overlayView.isUserInteractionEnabled = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTap(_:))))
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)
        self.overlayView = overlayView
    }
}
