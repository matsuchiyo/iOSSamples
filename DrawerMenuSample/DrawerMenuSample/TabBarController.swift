//
//  TabBarController.swift
//  DrawerMenuSample
//
//  Created by 松島勇貴 on 2020/04/14.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        // 担当しているプロジェクトだと、以下のような構造。
        // UITabBarController
        //   ┠ UINavigaitonController
        //   ┃  ┗ UIViewController
        //   ┠ UINavigaitonController
        //   ┃  ┗ UIViewController
        //   ..
        
        let firstViewController = FirstViewController()
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        firstNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let secondViewController = SecondViewController()
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        secondNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        viewControllers = [firstNavigationController, secondNavigationController]
    }
}
