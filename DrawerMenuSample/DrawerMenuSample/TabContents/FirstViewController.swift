//
//  FirstViewController.swift
//  DrawerMenuSample
//
//  Created by 松島勇貴 on 2020/04/14.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "First"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(menuButtonDidTap(_:)))
        view.backgroundColor = .white

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First"
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func menuButtonDidTap(_ sender: UIBarButtonItem) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("### no rootViewController")
            return
        }
        rootViewController.present(DrawerViewController(), animated: true)
    }
}
