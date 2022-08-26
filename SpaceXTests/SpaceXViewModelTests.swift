//
//  SpaceXViewModelTests.swift
//  SpaceXTests
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import XCTest
@testable import SpaceX

class SpaceXViewModelTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  func testCompanyInfoReturnsCorrectData() throws {
    let company = Company(name: "Test", founder: "Test-Founder", founded: 2000, employees: 10, vehicles: 10, launchSites: 10, testSites: 10, ceo: "Test-CEO", cto: "Test-CTO", coo: "Test-COO", ctoPropulsion: "", valuation: 1000, summary: "", id: "1")
    let sut = SpacexViewModel(repository: MockSpaceXCompanyRepository(company: company))
    sut.fetchCompany()
    let expectedInfo = "\(company.name) was founded by \(company.founder) in \(company.founded). It has now \(company.employees) employees, \(company.launchSites) launch sites, and is valued at USD \(company.valuation)"
    XCTAssert(expectedInfo == sut.companyInfo)
  }
  func testCompanyInfoReturnsInvalidData() throws {
    let company = Company(name: "Test", founder: "Test-Founder", founded: 2000, employees: 10, vehicles: 10, launchSites: 10, testSites: 10, ceo: "Test-CEO", cto: "Test-CTO", coo: "Test-COO", ctoPropulsion: "", valuation: 1000, summary: "", id: "1")
    let sut = SpacexViewModel(repository: MockSpaceXCompanyRepository(company: company))
    sut.fetchCompany()
    let expectedInfo = "\(company.name) wasfounded by \(company.founder) in \(company.founded). It has now \(company.employees) employees, \(company.launchSites) launch sites, and is valued at USD \(company.valuation)"
    XCTAssertFalse(expectedInfo == sut.companyInfo)
  }
  func testLaunchHasCorrectRocketAssigned() throws {
    let rockets = Rocket.stub(with: "1")
    let launch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil, links: nil, rocket: "1", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: nil)
    let launchResponse = LaunchResponse(docs: [launch], nextPage: 2, page: 1)
    let sut = SpacexViewModel(repository: MockLaunchRepository(rockets: rockets, launches: launchResponse))
    sut.fetchLaunches()
    XCTAssert(sut.launches.first?.rocket?.id == .some("1"))
  }
  func testLaunchDoesNotAddIncorrectRocketToResponse() throws {
    let rockets = Rocket.stub(with: "2")
    let launch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil, links: nil, rocket: "1", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: nil)
    let launchResponse = LaunchResponse(docs: [launch], nextPage: 2, page: 1)
    let sut = SpacexViewModel(repository: MockLaunchRepository(rockets: rockets, launches: launchResponse))
    sut.fetchLaunches()
    XCTAssertFalse(sut.launches.first?.rocket?.id == .some("1"))
  }
  func testLaunchSortedObjectsAreNotTheSame() throws {
    let rockets = Rocket.stub(with: "1")
    let launch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil, links: nil, rocket: "1", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: "1")
    let secondLaunch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil, links: nil, rocket: "2", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(timeIntervalSinceReferenceDate: -123456789.0), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: "2")
    let launchResponse = LaunchResponse(docs: [launch, secondLaunch], nextPage: 2, page: 1)
    let sut = SpacexViewModel(repository: MockLaunchRepository(rockets: rockets, launches: launchResponse))
    let unsortedLaunches = sut.launches.map { $0.launch.id ?? "" }
    sut.currentSortType = .ASC
    let sortedLaunches = sut.launches.map { $0.launch.id ?? "" }
    XCTAssertFalse(unsortedLaunches == sortedLaunches)
  }
  func testLaunchASCSortReturnsValidPosition() throws {
    let rockets = Rocket.stub(with: "1")
    let launch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil,links: nil, rocket: "1", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: "1")
    let secondLaunch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil,links: nil, rocket: "2", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(timeIntervalSinceReferenceDate: -123456789.0), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: "2")
    let launchResponse = LaunchResponse(docs: [launch, secondLaunch], nextPage: 2, page: 1)
    let sut = SpacexViewModel(repository: MockLaunchRepository(rockets: rockets, launches: launchResponse))
    sut.currentSortType = .ASC
    let sortedLaunches = sut.launches.map { $0.launch.id ?? "" }
    print(sortedLaunches)
    XCTAssertTrue(sortedLaunches == ["2", "1"], "Launches should be arranged ASC")
  }
  func testLaunchesYearFilterReturnsEmptyObjectForInvalidYear() throws {
    let rockets = Rocket.stub(with: "2")
    let launch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil,links: nil, rocket: "1", success: nil, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: nil)
    let launchResponse = LaunchResponse(docs: [launch], nextPage: 2, page: 1)
    let sut = SpacexViewModel(repository: MockLaunchRepository(rockets: rockets, launches: launchResponse))
    sut.selectedYearFilter = 2020
    XCTAssert(sut.launches.count == 0)
  }
}
