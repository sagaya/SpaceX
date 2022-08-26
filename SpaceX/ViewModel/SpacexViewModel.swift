//
//  SpacexViewModel.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import Foundation
import Combine

class SpacexViewModel {
  var repository: SpaceRepositoryProtocol
  @Published var companyInfo = ""
  @Published var launches: [SpaceXMappedModel] = []
  var sectionTitles = ["COMPANY", "LAUNCHES"]
  var yearFilters: [Int] = []
  var selectedYearFilter: Int = 0 {
    didSet {
      filterLaunchYears()
    }
  }
  var subscribers: [AnyCancellable] = []
  var currentSortType: SortType = .DESC {
    didSet {
      sortLaunches()
    }
  }
  let sortTypes: [SortType] = [.DESC, .ASC]
  init(repository: SpaceRepositoryProtocol = SpaceRepository()) {
    self.repository = repository
    fetchCompany()
    fetchLaunches()
  }
  func fetchCompany() {
    repository.fetchCompany()
      .sink { _ in } receiveValue: { company in
        self.companyInfo(from: company)
      }.store(in: &subscribers)
  }
  func fetchLaunches() {
    let nextPage = launches.first?.nextPage ?? 1
    repository.fetchLaunches(for: nextPage)
      .sink { completion in
      } receiveValue: { value in
        self.launches += value.sortLaunchOrder(by: self.currentSortType)
        self.getLaunchYears()
      }.store(in: &subscribers)
  }
  private func getLaunchYears() {
    self.yearFilters = launches.map {
      ($0.launch.launchYear ?? 0)
    }.unique()
    filterLaunchYears()
  }
  private func filterLaunchYears() {
    guard selectedYearFilter != 0 else { return }
    self.launches = self.launches.filter {
      return ($0.launch.launchYear ?? 0) == selectedYearFilter
    }
  }
  func getMediaURL(for launch: Launch) -> URL? {
    let launchURLString = launch.links?.wikipedia ?? launch.links?.webcast ?? launch.links?.article ?? ""
    return URL(string: launchURLString)
  }
  private func sortLaunches() {
    self.launches = self.launches.sortLaunchOrder(by: self.currentSortType)
  }
  private func companyInfo(from company: Company) {
    let info = "\(company.name) was founded by \(company.founder) in \(company.founded). It has now \(company.employees) employees, \(company.launchSites) launch sites, and is valued at USD \(company.valuation)"
    self.companyInfo = info
  }
}
