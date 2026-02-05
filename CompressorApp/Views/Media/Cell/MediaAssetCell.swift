//
//  MediaAssetCell.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class MediaAssetCell: UICollectionViewCell {
  static let reuseId = "MediaAssetCell"

  private let imageView = UIImageView()
  private let bestBadge = UIImageView()
  private let checkInner = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) { fatalError() }

  private func setupUI() {
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = true
    contentView.backgroundColor = .secondarySystemBackground

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true

    bestBadge.image = UIImage(named: "best_view_icon")
    bestBadge.isHidden = true
    
    [imageView, bestBadge, checkInner].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      bestBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      bestBadge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      bestBadge.widthAnchor.constraint(equalToConstant: 65),
      bestBadge.heightAnchor.constraint(equalToConstant: 25),

      checkInner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      checkInner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      checkInner.widthAnchor.constraint(equalToConstant: 24),
      checkInner.heightAnchor.constraint(equalToConstant: 24),
    ])
  }

  func configure(asset: MediaAsset, isSelected: Bool) {
    imageView.image = asset.preview
    bestBadge.isHidden = !asset.isBest
    
    
    let systemName = isSelected ? "square_fill_icon" : "square_icon"
    let image = UIImage(named: systemName)
    checkInner.image = image
  }
}
