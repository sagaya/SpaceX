//
//  Launch.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import Foundation

// MARK: - Launch
struct LaunchResponse: Codable {
  let docs: Launches
  let nextPage: Int
  let page: Int
}
struct Launch: Codable {
  let staticFireDateUTC: String?
  let staticFireDateUnix: Int?
  let net: Bool?
  let links: Links?
  let rocket: String?
  let success: Bool?
  let payloads: [String]?
  let flightNumber: Int?
  let name, dateUTC: String?
  let dateUnix: Int?
  let dateLocal: Date?
  let datePrecision: String?
  let upcoming: Bool?
  let autoUpdate, tbd: Bool?
  let launchLibraryID: String?
  let id: String?
  var launchDate: String? {
    get {
      if let date = dateLocal {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
      }
      return nil
    }
  }
  var launchTime: String? {
    get {
      if let date = dateLocal {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
      }
      return nil
    }
  }
  var launchYear: Int? {
    get {
      if let date = dateLocal {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year
      }
      return nil
    }
  }
  enum CodingKeys: String, CodingKey {
    case staticFireDateUTC = "static_fire_date_utc"
    case staticFireDateUnix = "static_fire_date_unix"
    case net, rocket, success, payloads
    case flightNumber = "flight_number"
    case name
    case dateUTC = "date_utc"
    case dateUnix = "date_unix"
    case dateLocal = "date_local"
    case datePrecision = "date_precision"
    case upcoming
    case autoUpdate = "auto_update"
    case tbd
    case launchLibraryID = "launch_library_id"
    case id, links
  }
}
typealias Launches = [Launch]

enum LaunchAPI: URLRequestBuilder {
  case fetchLatest(page: Int, limit: Int)
}
extension LaunchAPI {
  var path: String {
    return "/launches/query"
  }
  var body: [String : Any]? {
    switch self {
    case let .fetchLatest(page, limit):
      return [
        "options": [
          "page": page,
          "limit": limit
        ]
      ]
    }
  }
  var httpMethod: String {
    return "POST"
  }
}
