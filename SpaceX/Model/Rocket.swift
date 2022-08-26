//
//  Rocket.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 08/05/2022.
//

import Foundation

struct Rocket: Codable {
  let name, type, id: String
}
extension Rocket {
  static func stub(with id: String = UUID().uuidString) -> Rockets {
    let _rocket = Rocket(name: "Test rocket", type: "type", id: id)
    return [_rocket]
  }
}
typealias Rockets = [Rocket]

enum RocketAPI: URLRequestBuilder {
  case fetch
}
extension RocketAPI {
  var path: String {
    return "/rockets"
  }
  var body: [String : Any]? {
    return nil
  }
  var httpMethod: String {
    return "GET"
  }
}
