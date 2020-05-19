//
//  UsersRequest.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import Foundation

// https://api.github.com/search/users?page=3&per_page=10&q=Swift
struct UsersRequest: GithubRequest {
    typealias Response = UsersResponse
    
    var page: Int
    var perPage: Int
    
    var path: String {
        return "search/users"
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "q", value: "Swift"),
            .init(name: "order", value: "desc"),
            .init(name: "per_page", value: perPage.description),
            .init(name: "page", value: page.description),
        ]
    }
}

struct UsersResponse: Codable {
    var totalCount: Int
    var items: [User]
}

struct User: Codable {
    var login: String
    var id: Int
    var url: String
    var avatarUrl: String
}
