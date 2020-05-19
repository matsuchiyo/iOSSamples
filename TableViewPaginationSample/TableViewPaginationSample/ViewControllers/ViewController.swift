//
//  ViewController.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private weak var tabUsers: UIButton!
    private weak var tabRepos: UIButton!

    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
    private var viewControllers = [UsersViewController(), ReposViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([self.viewControllers.first!], direction: .forward, animated: true)
        
        tabUsers.isSelected = true
        tabUsers.addTarget(self, action: #selector(tabUserDidTap(_:)), for: .touchUpInside)
        tabRepos.addTarget(self, action: #selector(tabRepoDidTap(_:)), for: .touchUpInside)
    }
    
    @objc func tabUserDidTap(_ sender: UIButton) {
        tabUsers.isSelected = true
        tabRepos.isSelected = false
        let userIndex = 0
        let direction: UIPageViewController.NavigationDirection = {
            guard
                let currentViewController = pageViewController.viewControllers?.first,
                let currentIndex = self.viewControllers.firstIndex(of: currentViewController)
            else {
                return .forward
            }
            return userIndex > currentIndex ? .forward : .reverse
        }()
        
        pageViewController.setViewControllers([viewControllers[userIndex]], direction: direction, animated: true)
    }

    @objc func tabRepoDidTap(_ sender: UIButton) {
        tabUsers.isSelected = false
        tabRepos.isSelected = true
        let reposIndex = 1
        let direction: UIPageViewController.NavigationDirection = {
            guard
                let currentViewController = pageViewController.viewControllers?.first,
                let currentIndex = self.viewControllers.firstIndex(of: currentViewController)
            else {
                return .forward
            }
            return reposIndex > currentIndex ? .forward : .reverse
        }()
        
        pageViewController.setViewControllers([viewControllers[reposIndex]], direction: direction, animated: true)
    }

    private func initializeViews() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tabUsers = UIButton()
        tabUsers.translatesAutoresizingMaskIntoConstraints = false
        tabUsers.setTitleColor(.gray, for: .normal)
        tabUsers.setTitleColor(.black, for: .selected)
        tabUsers.setTitle("Users", for: .normal)
        view.addSubview(tabUsers)
        self.tabUsers = tabUsers
        
        let tabRepos = UIButton()
        tabRepos.translatesAutoresizingMaskIntoConstraints = false
        tabRepos.setTitleColor(.gray, for: .normal)
        tabRepos.setTitleColor(.black, for: .selected)
        tabRepos.setTitle("Repos", for: .normal)
        view.addSubview(tabRepos)
        self.tabRepos = tabRepos
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.backgroundColor = .gray
        view.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            tabUsers.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabUsers.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            tabRepos.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabRepos.leadingAnchor.constraint(equalTo: tabUsers.trailingAnchor),
            tabRepos.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tabUsers.widthAnchor.constraint(equalTo: tabRepos.widthAnchor),
            tabUsers.heightAnchor.constraint(equalTo: tabRepos.heightAnchor),
            
            pageViewController.view.topAnchor.constraint(equalTo: tabUsers.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let oldIndex = self.viewControllers.firstIndex(of: viewController) else { return nil }
        let newIndex = oldIndex - 1
        guard newIndex > 0 else { return nil }
        return self.viewControllers[newIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let oldIndex = self.viewControllers.firstIndex(of: viewController) else { return nil }
        let newIndex = oldIndex + 1
        guard newIndex < viewControllers.count else { return nil }
        return self.viewControllers[newIndex]
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = viewControllers.firstIndex(of: currentViewController)
        else {
            return
        }
        
        tabUsers.isSelected = currentIndex == 0 ? true : false
        tabRepos.isSelected = currentIndex == 1 ? true : false
    }
}
