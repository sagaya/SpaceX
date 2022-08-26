//
//  URLRequestBuilder.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import UIKit

protocol URLRequestBuilder {
  var baseURL: URL { get }
  var requestURL: URL { get }
  var path: String { get }
  var httpMethod: String { get }
  var request: URLRequest { get }
  var body: [String:Any]? { get }
}

extension URLRequestBuilder {
  var baseURL: URL {
    let baseURLString = "https://api.spacexdata.com/v4"
    return URL(string: baseURLString)!
  }
  
  var requestURL: URL {
    return URL(string: "\(baseURL)\(path)")!
  }
  var request: URLRequest {
    var request = URLRequest(url: requestURL)
    request.httpMethod = httpMethod
    if let body = body {
      request.httpBody = try? convertDictionaryToJSONData(body)
    }
    return request
  }
  func convertDictionaryToJSONData(_ dict: [String: Any]) throws -> Data {
    let jsonData = try JSONSerialization.data(withJSONObject: dict)
    return jsonData
  }
}
