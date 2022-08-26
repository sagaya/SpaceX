//
//  SpaceXViewControllerTests.swift
//  SpaceXTests
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import XCTest
@testable import SpaceX

class SpaceXViewControllerTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  func testViewDidLoadRendersLaunches() {
    XCTAssertEqual(makeSUT(launches: []).tableView.numberOfRows(inSection: 1), 0)
    XCTAssertEqual(makeSUT(launches: [makeDummyLaunch()]).tableView.numberOfRows(inSection: 1), 1)
  }
  func testViewdidLoadWithFailedLaunchRendersStatusImage() {
    let launch = makeDummyLaunch(success: false)
    let sut = makeSUT(launches: [launch])
    let indexPath = IndexPath(item: 0, section: 1)
    let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? LaunchesCell
    XCTAssertNotNil(cell)
    XCTAssertTrue(cell?.statusImageView.accessibilityIdentifier == .some("xmark-status"))
  }
  func testViewdidLoadWithSuccessfulLaunchRendersSuccessStatusImage() {
    let launch = makeDummyLaunch(success: true)
    let sut = makeSUT(launches: [launch])
    let indexPath = IndexPath(item: 0, section: 1)
    let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? LaunchesCell
    XCTAssertNotNil(cell)
    XCTAssertTrue(cell?.statusImageView.accessibilityIdentifier == .some("checkmark-status"))
  }
  func makeSUT(launches: Launches) -> ViewController {
    let rockets = Rocket.stub(with: "1")
    let launchResponse = LaunchResponse(docs: launches, nextPage: 2, page: 1)
    let viewModel = SpacexViewModel(repository: MockLaunchRepository(rockets: rockets, launches: launchResponse))
    let sut = ViewController(viewModel: viewModel)
    _ = sut.view
    return sut
  }
  func makeDummyLaunch(success: Bool = false) -> Launch {
    let launch = Launch(staticFireDateUTC: nil, staticFireDateUnix: nil, net: nil, links: nil, rocket: "1", success: success, payloads: nil, flightNumber: nil, name: nil, dateUTC: nil, dateUnix: nil, dateLocal: Date(), datePrecision: nil, upcoming: nil, autoUpdate: nil, tbd: nil, launchLibraryID: nil, id: nil)
    return launch
  }
}
