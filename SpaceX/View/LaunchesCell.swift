//
//  LaunchesCell.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 08/05/2022.
//

import UIKit
import Combine

class LaunchesCell: UITableViewCell {
  let launchImage = UIImageView()
  let nameLabel = UILabel()
  let dateTime = UILabel()
  let rocketLabel = UILabel()
  let dateSinceLabel = UILabel()
  let statusImageView = UIImageView()
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?
  
  var launch: SpaceXMappedModel? {
    didSet {
      let statusImage = launch?.launch.success == .some(true) ? "checkmark" : "xmark"
      statusImageView.accessibilityIdentifier = "\(statusImage)-status"
      statusImageView.image = UIImage(systemName: statusImage)
      
      if let name = launch?.launch.name, let date = launch?.launch.launchDate, let time = launch?.launch.launchTime, let rocket = launch?.rocket, let localDate = launch?.launch.dateLocal, let launchImage = launch?.launch.links?.patch.small {
        nameLabel.text = "Mission: \(name)"
        dateTime.text = "Date/time: \(date) at \(time)"
        rocketLabel.text = "Rocket: \(rocket.name)"
        var dateSince = "Date "
        dateSince += localDate >= Date() ? "from now: +" : "since now: -"
        dateSince += "\(date)"
        dateSinceLabel.text = dateSince
        cancellable = loadImage(for: launchImage).sink { [weak self] image in
          guard let self = self else { return }
          self.showImage(image: image)
        }
      }
    }
  }
  private func loadImage(for launch: String) -> AnyPublisher<UIImage?, Never> {
    return Just(launch)
      .flatMap({ image -> AnyPublisher<UIImage?, Never> in
        if let url = URL(string: image) {
          return ImageLoader.shared.loadImage(from: url)
        }
        return Just(UIImage())
          .eraseToAnyPublisher()
      })
      .eraseToAnyPublisher()
  }
  private func showImage(image: UIImage?) {
    launchImage.alpha = 0.0
    animator?.stopAnimation(false)
    launchImage.image = image
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.launchImage.alpha = 1.0
    })
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(launchImage)
    let detailStackView = UIStackView(arrangedSubviews: [nameLabel,dateTime,rocketLabel,dateSinceLabel])
    detailStackView.spacing = 10
    detailStackView.alignment = .fill
    detailStackView.axis = .vertical
    dateSinceLabel.numberOfLines = 0
    rocketLabel.numberOfLines = 0
    dateTime.numberOfLines = 0
    nameLabel.numberOfLines = 0
    statusImageView.tintColor = .black
    addSubview(detailStackView)
    addSubview(statusImageView)
    statusImageView.translatesAutoresizingMaskIntoConstraints = false
    detailStackView.translatesAutoresizingMaskIntoConstraints = false
    launchImage.translatesAutoresizingMaskIntoConstraints = false
    detailStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      launchImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      launchImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      launchImage.widthAnchor.constraint(equalToConstant: 30),
      launchImage.heightAnchor.constraint(equalToConstant: 30),
      
      statusImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      statusImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      statusImageView.widthAnchor.constraint(equalToConstant: 30),
      statusImageView.heightAnchor.constraint(equalToConstant: 30),
      
      detailStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      detailStackView.leadingAnchor.constraint(equalTo: launchImage.trailingAnchor, constant: 10),
      detailStackView.trailingAnchor.constraint(equalTo: statusImageView.leadingAnchor, constant: -10),
      detailStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])
    
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    launchImage.image = nil
    statusImageView.image = nil
    launchImage.alpha = 0.0
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
