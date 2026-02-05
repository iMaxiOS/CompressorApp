//
//  MediaItemCell.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class MediaItemCell: UICollectionViewCell {
  static let reuseId = "MediaItemCell"

  private let iconView = UIImageView()
  private let titleLabel = UILabel()
  private let countLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) { fatalError() }

  private func setupUI() {
    contentView.backgroundColor = .systemBackground
    contentView.layer.cornerRadius = 10
    contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
    contentView.layer.shadowOpacity = 0.2
    contentView.layer.shadowRadius = 10
    contentView.layer.masksToBounds = false

    iconView.contentMode = .scaleAspectFit

    titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
    titleLabel.textColor = .label

    countLabel.font = .systemFont(ofSize: 14, weight: .regular)
    countLabel.textColor = .secondaryLabel
    
    [iconView, titleLabel, countLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }

    NSLayoutConstraint.activate([
      iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconView.widthAnchor.constraint(equalToConstant: 44),
      iconView.heightAnchor.constraint(equalToConstant: 44),

      titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 14),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

      countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
      countLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      countLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      countLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -14),
    ])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
  }

  func configure(_ item: MediaItem) {
    iconView.image = item.icon
    titleLabel.text = item.title
    countLabel.text = item.countText
  }
}
