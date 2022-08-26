//
//  NetworkServiceProtocol.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import Foundation
import Combine
protocol NetworkServiceProtocol: AnyObject {
  var manager: URLSession {
    get set
  }
  func execute<T: Codable>(_ request: URLRequest, model: T.Type) -> AnyPublisher<T, Error>
}

extension NetworkServiceProtocol {
  func execute<T>(_ request: URLRequest, model: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return manager.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: T.self, decoder: decoder)
      .catch { error in
        Empty<T, Error>()
      }
      .eraseToAnyPublisher()
  }
}
