//
//  ViewController.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
  let tableView = UITableView()
  var viewModel: SpacexViewModel
  let companySection = CompanySection()
  var subscribers: [AnyCancellable] = []
  let pickerView = UIPickerView()
  let screenWidth = UIScreen.main.bounds.width - 10
  let screenHeight = UIScreen.main.bounds.height / 2

  init(viewModel: SpacexViewModel = SpacexViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    viewSetup()
    listners()
  }
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return viewModel.sortTypes.count
    }
    return viewModel.yearFilters.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 0{
      return viewModel.sortTypes[row].rawValue
    }
    return "\(viewModel.yearFilters[row])"
  }
  func viewSetup() {
    view.addSubview(tableView)
    title = "SpaceX"
    navigationController?.navigationBar.prefersLargeTitles = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.register(CompanySection.self, forCellReuseIdentifier: String(describing: CompanySection.self))
    tableView.register(LaunchesCell.self, forCellReuseIdentifier: String(describing: LaunchesCell.self))
    tableView.delegate = self
    tableView.dataSource = self
    pickerView.delegate = self
    pickerView.dataSource = self
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(showFilterPopup))
  }
  func listners() {
    viewModel.$companyInfo
      .receive(on: RunLoop.main)
      .sink { info in
        self.tableView.beginUpdates()
        self.companySection.companyInfo.text = info
        self.tableView.endUpdates()
      }.store(in: &subscribers)
    viewModel.$launches
      .receive(on: RunLoop.main)
      .sink { _ in
        self.tableView.reloadData()
      }.store(in: &subscribers)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.sectionTitles.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return viewModel.launches.count
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      return companySection
    }
    if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LaunchesCell.self)) as? LaunchesCell {
      cell.launch = viewModel.launches[indexPath.row]
      return cell
    }else {
      return UITableViewCell()
    }
  }
  @objc private func showFilterPopup() {
    let vc = UIViewController()
    vc.preferredContentSize = CGSize(width: self.screenWidth, height: self.screenHeight)
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height:self.screenHeight))
    pickerView.dataSource = self
    pickerView.delegate = self
    vc.view.addSubview(pickerView)
    pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
    pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
    let selectedIndex = viewModel.sortTypes.firstIndex(of: viewModel.currentSortType)
    pickerView.selectRow(selectedIndex ?? 0, inComponent: 0, animated: false)
    let alert = UIAlertController(title: "Filter", message: "", preferredStyle: .actionSheet)
    
    alert.setValue(vc, forKey: "contentViewController")
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.sectionTitles[section]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      let selectedSort = viewModel.sortTypes[row]
      viewModel.currentSortType = selectedSort
    }else {
      let selectedYearSort = viewModel.yearFilters[row]
      viewModel.selectedYearFilter = selectedYearSort
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      let selectedLaunch = viewModel.launches[indexPath.row]
      openLaunchWebPage(launch: selectedLaunch.launch)
    }
  }
  func openLaunchWebPage(launch: Launch) {
    if let launchURL = viewModel.getMediaURL(for: launch) {
      UIApplication.shared.open(launchURL)
    }
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard indexPath.section == 1 else { return }
    if indexPath.row == viewModel.launches.count - 1 {
      viewModel.fetchLaunches()
    }
  }
}
