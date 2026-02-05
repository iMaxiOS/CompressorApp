//
//  MediaItemCell.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class MediaItemCell: UICollectionViewCell {
  static let reuseId = "MediaItemCell"

  private let iconContainer = UIView()
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
    contentView.layer.cornerRadius = 16
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.08
    contentView.layer.shadowRadius = 10
    contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
    contentView.layer.masksToBounds = false

    iconContainer.layer.cornerRadius = 22
    iconContainer.translatesAutoresizingMaskIntoConstraints = false

    iconView.contentMode = .scaleAspectFit
    iconView.tintColor = .systemIndigo
    iconView.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    titleLabel.textColor = .label
    titleLabel.numberOfLines = 2
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    countLabel.font = .systemFont(ofSize: 14, weight: .regular)
    countLabel.textColor = .secondaryLabel
    countLabel.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(iconContainer)
    iconContainer.addSubview(iconView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(countLabel)

    NSLayoutConstraint.activate([
      iconContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconContainer.widthAnchor.constraint(equalToConstant: 44),
      iconContainer.heightAnchor.constraint(equalToConstant: 44),

      iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
      iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 22),
      iconView.heightAnchor.constraint(equalToConstant: 22),

      titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 14),
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
    // чтобы тень не лагала и была красивой
    contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
  }

  func configure(_ item: MediaItem) {
    iconContainer.backgroundColor = item.iconBackground
    iconView.image = item.icon
    titleLabel.text = item.title
    countLabel.text = item.countText
  }
}
