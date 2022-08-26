//
//  Link.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 12/05/2022.
//

import Foundation

// MARK: - Links
struct Links: Codable {
  let patch: Patch
  let webcast: String?
  let youtubeID: String
  let article: String?
  let wikipedia: String?
  
  enum CodingKeys: String, CodingKey {
    case patch, webcast
    case youtubeID = "youtube_id"
    case article, wikipedia
  }
}
// MARK: - Patch
struct Patch: Codable {
  let small, large: String
}
