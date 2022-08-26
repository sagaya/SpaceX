//
//  NetworkService.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
  var manager: URLSession = URLSession.shared
  public static let `default`: NetworkServiceProtocol = {
    var service = NetworkService()
    return service
  }()
  public init() {}
}
