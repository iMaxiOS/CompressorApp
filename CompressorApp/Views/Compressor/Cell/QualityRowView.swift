//
//  QualityRowView.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit

final class QualityRowView: UIControl {
  var onTap: (() -> Void)?
  
  private let titleLabel = UILabel()
  private let check = UIImageView()
  
  init(title: String) {
    super.init(frame: .zero)
    setupUI(title: title)
    bind()
  }
  required init?(coder: NSCoder) { fatalError() }
  
  private func setupUI(title: String) {
    layer.cornerRadius = 14
    layer.borderWidth = 1
    layer.borderColor = UIColor.separator.cgColor
    
    titleLabel.text = title
    titleLabel.textColor = #colorLiteral(red: 0.3254901961, green: 0.4117647059, blue: 0.9294117647, alpha: 1)
    titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    
    check.image = UIImage(systemName: "checkmark.circle.fill")
    check.tintColor = #colorLiteral(red: 0.3254901961, green: 0.4117647059, blue: 0.9294117647, alpha: 1)
    check.isHidden = true
    
    [titleLabel, check].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      
      check.centerYAnchor.constraint(equalTo: centerYAnchor),
      check.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      check.widthAnchor.constraint(equalToConstant: 24),
      check.heightAnchor.constraint(equalToConstant: 24),
    ])
  }
  
  private func bind() {
    addTarget(self, action: #selector(tapped), for: .touchUpInside)
  }
  
  @objc private func tapped() { onTap?() }
  
  func setChecked(_ checked: Bool, animated: Bool) {
    if animated {
      if checked {
        check.isHidden = false
        check.alpha = 0
        check.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut]) {
          self.check.alpha = 1
          self.check.transform = .identity
        }
      } else {
        UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseIn]) {
          self.check.alpha = 0
          self.check.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
          self.check.isHidden = true
          self.check.alpha = 1
          self.check.transform = .identity
        }
      }
    } else {
      check.isHidden = !checked
    }
  }
}
