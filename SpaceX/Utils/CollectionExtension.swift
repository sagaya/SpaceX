//
//  CollectionExtension.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import Foundation

enum SortType: String {
case ASC,DESC
}

extension Collection where Element == SpaceXMappedModel {
  func sortLaunchOrder(by type: SortType) -> [SpaceXMappedModel] {
    let sortedList = sorted { lhs, rhs in
      guard let lhsDate = lhs.launch.dateLocal, let rhsDate = rhs.launch.dateLocal else {
        return false
      }
      if type == .ASC {
        return lhsDate < rhsDate
      }else {
        return lhsDate > rhsDate
      }
    }
    return sortedList
  }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
