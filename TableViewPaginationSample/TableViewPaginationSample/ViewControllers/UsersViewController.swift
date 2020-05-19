//
//  UsersViewController.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import Foundation
import UIKit

class UsersViewController: UIViewController {
    
    private static let reusableIdentifier = "Cell"
    private static let perPage = 20
    
    let apiService: APIServiceType
    
    var items: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var nextPage = 0
    
    var totalCount = Int.max
    
    private weak var tableView: UITableView!

    init(apiService: APIServiceType = APIService()) {
        self.apiService = apiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        fetchItems()
    }
    
    @objc func refresh() {
        nextPage = 0
        totalCount = 0
        fetchItems()
    }

    private func initializeViews() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        view.addSubview(tableView)
        self.tableView = tableView
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func fetchItems() {
        guard items.count < totalCount else { return }
        apiService.response(from: UsersRequest(page: nextPage, perPage: Self.perPage)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }

            switch result {
            case .success(let response):
                self.items += response.items
                self.nextPage += 1
                self.totalCount = response.totalCount
            case .failure(let error):
                switch error {
                case .responseError(let error):
                    self.showAlert(title: "Response Error", description: error.localizedDescription)
                case .parseError(let data):
                    self.showAlert(title: "Parse Error", description: String(data: data, encoding: .utf8) ?? "")
                }
            }
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        fetchMoreItemsIfNeeded(indexPath: indexPath)

        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reusableIdentifier)!
        cell.textLabel?.text = item.login
        return cell
    }

    private func fetchMoreItemsIfNeeded(indexPath: IndexPath) {
        if indexPath.row == items.count - 10 {
            fetchItems()
        }
    }
}
