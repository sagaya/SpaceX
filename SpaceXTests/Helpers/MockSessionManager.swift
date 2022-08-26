//
//  MockSessionManager.swift
//  SpaceXTests
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import UIKit
@testable import SpaceX

enum MockSessionManager {
  static let manager: URLSession = {
    let configuration: URLSessionConfiguration = {
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [MockURLProtocol.self]
      return configuration
    }()
    return URLSession(configuration: configuration)
  }()
}


class MockNetworkService: NetworkServiceProtocol {
  var manager: URLSession = MockSessionManager.manager
  var cache: URLCache = URLCache.shared
  public static let `default`: NetworkServiceProtocol = {
    var service = MockNetworkService()
    return service
  }()
  public init() {}

}
