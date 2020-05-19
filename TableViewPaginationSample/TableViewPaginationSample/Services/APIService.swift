//
//  APIService.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import Foundation

enum APIResult<Value, APIServiceError> {
    case success(_ value: Value)
    case failure(_ error: APIServiceError)
}

enum APIServiceError: Error {
    case responseError(_ error: Error)
    case parseError(_ data: Data)
}

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

protocol APIServiceType {
    func response<Request>(from request: Request, completion: @escaping (Result<Request.Response, APIServiceError>) -> Void) where Request: APIRequestType
}

class APIService: APIServiceType {
    func response<Request>(from request: Request, completion: @escaping (Result<Request.Response, APIServiceError>) -> Void) where Request : APIRequestType {
        let pathURL = URL(string: request.path, relativeTo: request.baseURL)!
        
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.responseError(error)))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let value = try decoder.decode(Request.Response.self, from: data!)
                completion(.success(value))
            } catch {
                completion(.failure(.parseError(data!)))
            }
        }
        task.resume()
    }
}
