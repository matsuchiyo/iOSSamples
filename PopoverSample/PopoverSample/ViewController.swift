//
//  ViewController.swift
//  PopoverSample
//
//  Created by 松島勇貴 on 2020/05/19.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Inspired by https://qiita.com/hsylife/items/9df3dee1fc70b244da8c
    @IBAction func showPopover1(_ sender: Any) {
        let contentViewController = ContentViewController()
        contentViewController.modalPresentationStyle = .popover
        contentViewController.popoverPresentationController?.sourceView = view
        contentViewController.popoverPresentationController?.sourceRect = (sender as! UIButton).frame
        contentViewController.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0) // 0: hide arrow
        contentViewController.popoverPresentationController?.delegate = self
        
        contentViewController.preferredContentSize = CGSize(width: 300, height: 300)
        present(contentViewController, animated: true)
    }
    
    @IBAction func showPopover2(_ sender: Any) {
        let contentViewController = ContentViewController()
        contentViewController.modalPresentationStyle = .custom
        contentViewController.transitioningDelegate = self
//        contentViewController.preferredContentSize = CGSize(width: 300, height: 300)
        present(contentViewController, animated: true)
    }
}


extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopoverPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
