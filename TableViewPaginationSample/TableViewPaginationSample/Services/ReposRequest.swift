//
//  ReposRequest.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import Foundation

// https://api.github.com/search/repositories?page=3&per_page=10&q=Swift
struct ReposRequest: GithubRequest {
    typealias Response = ReposResponse
    
    var page: Int
    var perPage: Int
    
    var path: String {
        return "search/repositories"
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "q", value: "Swift UITableView Easy"),
            .init(name: "order", value: "desc"),
            .init(name: "per_page", value: perPage.description),
            .init(name: "page", value: page.description),
        ]
    }
    
}

struct ReposResponse: Codable {
    var totalCount: Int
    var items: [Repo]
}

struct Repo: Codable {
    var id: Int
    var fullName: String
}
