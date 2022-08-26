//
//  MockSpaceXRepository.swift
//  SpaceXTests
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import Foundation
import Combine
@testable import SpaceX

class MockSpaceXCompanyRepository: SpaceRepositoryProtocol {
  var service: NetworkServiceProtocol = MockNetworkService()
  var company: Company
  init(company: Company) {
    self.company = company
  }
  func fetchCompany() -> AnyPublisher<Company, Error> {
    return Just<Company>(company)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
