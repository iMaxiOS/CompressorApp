//
//  MediaGroupHeaderView.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class MediaGroupHeaderView: UICollectionReusableView {
  static let reuseId = "MediaGroupHeaderView"
  
  let titleLabel = UILabel()
  let actionButton = UIButton(type: .system)
  
  var onTap: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) { fatalError() }
  
  private func setupUI() {
    titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
    titleLabel.textColor = .secondaryLabel
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    actionButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    actionButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
    
    addSubview(titleLabel)
    addSubview(actionButton)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  @objc private func tap() { onTap?() }
}
