//
//  Company.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import Foundation

struct Company: Codable {
  let name, founder: String
  let founded, employees, vehicles, launchSites: Int
  let testSites: Int
  let ceo, cto, coo, ctoPropulsion: String
  let valuation: Int
  let summary, id: String

  enum CodingKeys: String, CodingKey {
    case name, founder, founded, employees, vehicles
    case launchSites = "launch_sites"
    case testSites = "test_sites"
    case ceo, cto, coo
    case ctoPropulsion = "cto_propulsion"
    case valuation, summary, id
  }
}

enum CompanyAPI: URLRequestBuilder {
  case fetchCompany
}
extension CompanyAPI {
  var path: String {
    return "/company"
  }
  var body: [String : Any]? {
    return nil
  }
  var httpMethod: String {
    return "GET"
  }
}
