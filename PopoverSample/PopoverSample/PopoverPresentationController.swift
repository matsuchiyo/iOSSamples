//
//  PopoverPresentationController.swift
//  PopoverSample
//
//  Created by 松島勇貴 on 2020/05/19.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    weak var overlayView: UIView?
    
    override func presentationTransitionWillBegin() {
        addOverlayView()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView?.alpha = 0.7
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
    
    /*
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
//        return CGSize(width: parentSize.width - (marginLeft + marginRight), height: parentSize.height - (marginTop + marginBottom))
        return presentedViewController.preferredContentSize;
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let childSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        let x = (containerView!.frame.width - childSize.width) / 2
        let y = (containerView!.frame.height - childSize.height) / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: childSize)
    }
 */
    
    override func containerViewWillLayoutSubviews() {
        print("### PopoverPresentationController.containerViewWillLayoutSubviews")
        overlayView?.frame = containerView!.bounds
        
        let presentedViewSize = presentedView!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let x = (containerView!.bounds.width - presentedViewSize.width) / 2
        let y = (containerView!.bounds.height - presentedViewSize.height) / 2
        presentedView?.frame = CGRect(origin: CGPoint(x: x, y: y), size: presentedViewSize)
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }
    
    override func containerViewDidLayoutSubviews() {
        // do nothing
    }
    
    
    @objc func overlayViewDidTap(_ sender: UITapGestureRecognizer) {
        print("### overlayViewDidTap")
        presentedViewController.dismiss(animated: true)
    }
    
    private func addOverlayView() {
        guard let containerView = containerView else { return }
        
        let overlayView = UIView()
        overlayView.frame = containerView.bounds
        overlayView.isUserInteractionEnabled = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTap(_:))))
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)
        self.overlayView = overlayView
    }
}
