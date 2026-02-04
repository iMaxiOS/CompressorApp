//
//  SectionCardView.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import UIKit

final class SectionCardView: UIControl {
  
  private let iconView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let viewAllLabel = UILabel()
  private let lockView = UIImageView()
  private let chevronView = UIImageView()
  
  var onLockTap: (() -> Void)?
  var onTapCompressor: (() -> Void)?
  var onTapMedia: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func setup() {
    backgroundColor = .clear
    
    iconView.contentMode = .scaleAspectFit
    iconView.tintColor = .systemBlue
    iconView.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    titleLabel.textColor = .label
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    viewAllLabel.font = .systemFont(ofSize: 16, weight: .regular)
    viewAllLabel.text = "View all"
    viewAllLabel.textColor = .secondaryLabel
    viewAllLabel.translatesAutoresizingMaskIntoConstraints = false
    
    subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    lockView.image = UIImage(named: "lock_icon")
    lockView.tintColor = .systemRed
    lockView.translatesAutoresizingMaskIntoConstraints = false
    lockView.isHidden = true
    
    chevronView.image = UIImage(named: "right_icon")
    chevronView.tintColor = .tertiaryLabel
    chevronView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(iconView)
    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(lockView)
    addSubview(chevronView)
    addSubview(viewAllLabel)
    
    NSLayoutConstraint.activate([
      iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
      iconView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      iconView.widthAnchor.constraint(equalToConstant: 24),
      iconView.heightAnchor.constraint(equalToConstant: 24),
      
      titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      
      subtitleLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      chevronView.centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor),
      chevronView.trailingAnchor.constraint(equalTo: lockView.trailingAnchor),
      chevronView.widthAnchor.constraint(equalToConstant: 20),
      chevronView.heightAnchor.constraint(equalToConstant: 20),
      
      viewAllLabel.centerYAnchor.constraint(equalTo: chevronView.centerYAnchor),
      viewAllLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor),
      
      lockView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      lockView.trailingAnchor.constraint(equalTo: trailingAnchor),
      lockView.widthAnchor.constraint(equalToConstant: 24),
      lockView.heightAnchor.constraint(equalToConstant: 24),
      
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: lockView.leadingAnchor, constant: -8)
    ])
    
    addTarget(self, action: #selector(onTap), for: [.touchDown])
    addTarget(self, action: #selector(tapUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
  }
  
  @objc private func onTap() {
    UIView.animate(withDuration: 0.12) { self.alpha = 0.75 }
    onLockTap?()
    onTapCompressor?()
    onTapMedia?()
  }
  
  @objc private func tapUp() {
    UIView.animate(withDuration: 0.12) { self.alpha = 1.0 }
  }
  
  func setLocked(_ locked: Bool) {
    isHidden = !locked
  }
  
  func configure(icon: UIImage?, title: String, subtitle: String, isViewAllLabel: Bool = true, locked: Bool, showsChevron: Bool = true) {
    iconView.image = icon
    titleLabel.text = title
    subtitleLabel.text = subtitle
    lockView.isHidden = !locked
    chevronView.isHidden = !showsChevron
    viewAllLabel.isHidden = !isViewAllLabel
    isUserInteractionEnabled = true
    accessibilityLabel = title
  }
}
