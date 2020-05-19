//
//  GithubRequest.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import Foundation

protocol GithubRequest: APIRequestType {
}

extension GithubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

struct GithubError: Error, Codable {
    var message: String
}
