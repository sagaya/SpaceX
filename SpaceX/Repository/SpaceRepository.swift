//
//  SpaceRepository.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 08/05/2022.
//

import Foundation
import Combine

struct SpaceXMappedModel: Equatable {
  static func == (lhs: SpaceXMappedModel, rhs: SpaceXMappedModel) -> Bool {
    lhs.launch.id == rhs.launch.id
  }
  let launch: Launch
  let nextPage: Int
  let rocket: Rocket?
}

protocol SpaceRepositoryProtocol {
  func fetchLaunches(for page: Int) -> AnyPublisher<[SpaceXMappedModel], Error>
  func fetchLaunch(for page: Int) -> AnyPublisher<LaunchResponse, Error>
  func fetchRockets() -> AnyPublisher<Rockets, Error>
  func fetchCompany() -> AnyPublisher<Company, Error>
  var service: NetworkServiceProtocol { get }
}

class SpaceRepository: SpaceRepositoryProtocol {
  var service: NetworkServiceProtocol = NetworkService()
}

extension SpaceRepositoryProtocol {
  func fetchLaunches(for page: Int) -> AnyPublisher<[SpaceXMappedModel], Error> {
    return Publishers.Zip(fetchLaunch(for: page), fetchRockets())
      .map { launches, rockets -> [SpaceXMappedModel] in
        let mappedLaunches = launches.docs.map { launch in
          SpaceXMappedModel(launch: launch, nextPage: launches.nextPage, rocket: rockets.first(where: { $0.id == (launch.rocket ?? "") }))
        }
        return mappedLaunches
      }
      .eraseToAnyPublisher()
  }
  func fetchCompany() -> AnyPublisher<Company, Error> {
    return service.execute(CompanyAPI.fetchCompany.request, model: Company.self)
  }
  func fetchLaunch(for page: Int) -> AnyPublisher<LaunchResponse, Error> {
    let request = service.execute(LaunchAPI.fetchLatest(page: page, limit: 10).request, model: LaunchResponse.self)
    return request
  }
  func fetchRockets() -> AnyPublisher<Rockets, Error> {
    let request = service.execute(RocketAPI.fetch.request, model: Rockets.self)
    return request
  }
}
