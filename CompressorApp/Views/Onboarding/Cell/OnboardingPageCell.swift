//
//  OnboardingPageCell.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//
import UIKit

final class OnboardingCell: UICollectionViewCell {
  static let reuseId = "OnboardingCell"
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func setup() {
    contentView.backgroundColor = .systemBackground
    
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 2
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 3
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 28),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.55),
      
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
    ])
  }
  
  func configure(_ page: OnboardingPage) {
    imageView.image = page.image
    titleLabel.text = page.title
    subtitleLabel.text = page.subtitle
  }
}
