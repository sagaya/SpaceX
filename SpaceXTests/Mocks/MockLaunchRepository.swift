//
//  MockLaunchRepository.swift
//  SpaceXTests
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import Foundation
import Combine
@testable import SpaceX

class MockLaunchRepository: SpaceRepositoryProtocol {
  var service: NetworkServiceProtocol = MockNetworkService()
  var rockets: Rockets
  var launches: LaunchResponse
  init(rockets: Rockets, launches: LaunchResponse) {
    self.rockets = rockets
    self.launches = launches
  }
  func fetchRockets() -> AnyPublisher<Rockets, Error> {
    return Just<Rockets>(rockets)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  func fetchLaunch(for page: Int) -> AnyPublisher<LaunchResponse, Error> {
    return Just<LaunchResponse>(launches)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}

