//
//  CompanySection.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 06/05/2022.
//

import UIKit

class CompanySection: UITableViewCell {
  let companyInfo = UILabel()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    companyInfo.numberOfLines = 0
    addSubview(companyInfo)
    companyInfo.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      companyInfo.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      companyInfo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      companyInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      companyInfo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

