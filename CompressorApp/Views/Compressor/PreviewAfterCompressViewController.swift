//
//  PreviewAfterCompressViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit
final class PreviewAfterCompressViewController: UIViewController {

  private let viewModel: PreviewAfterCompressViewModel

  private let preview = UIView()
  private let oldLabel = UILabel()
  private let newLabel = UILabel()
  private let deleteButton = UIButton(type: .system)
  private let keepButton = UIButton(type: .system)

  init(viewModel: PreviewAfterCompressViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Video Compressor"

    preview.backgroundColor = .black
    preview.layer.cornerRadius = 16
    preview.layer.masksToBounds = true
    preview.translatesAutoresizingMaskIntoConstraints = false

    oldLabel.text = "Old Size\n30.88 MB"
    oldLabel.numberOfLines = 2
    oldLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    oldLabel.translatesAutoresizingMaskIntoConstraints = false

    newLabel.text = "Now\n15.75 MB"
    newLabel.numberOfLines = 2
    newLabel.textAlignment = .right
    newLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    newLabel.textColor = .systemBlue
    newLabel.translatesAutoresizingMaskIntoConstraints = false

    deleteButton.setTitle("Delete Original Video", for: .normal)
    deleteButton.titleLabel?.font = .systemFont(ofSize: 15)
    deleteButton.setTitleColor(.systemBlue, for: .normal)
    deleteButton.translatesAutoresizingMaskIntoConstraints = false

    var cfg = UIButton.Configuration.filled()
    cfg.title = "Keep Original Video"
    cfg.cornerStyle = .large
    cfg.baseBackgroundColor = .systemIndigo
    cfg.baseForegroundColor = .white
    cfg.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    keepButton.configuration = cfg
    keepButton.translatesAutoresizingMaskIntoConstraints = false

    [preview, oldLabel, newLabel, deleteButton, keepButton].forEach(view.addSubview)

    NSLayoutConstraint.activate([
      preview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      preview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      preview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      preview.heightAnchor.constraint(equalTo: preview.widthAnchor, multiplier: 0.95),

      oldLabel.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 12),
      oldLabel.leadingAnchor.constraint(equalTo: preview.leadingAnchor),

      newLabel.topAnchor.constraint(equalTo: oldLabel.topAnchor),
      newLabel.trailingAnchor.constraint(equalTo: preview.trailingAnchor),

      deleteButton.topAnchor.constraint(equalTo: oldLabel.bottomAnchor, constant: 10),
      deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      keepButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 12),
      keepButton.leadingAnchor.constraint(equalTo: preview.leadingAnchor),
      keepButton.trailingAnchor.constraint(equalTo: preview.trailingAnchor),
      keepButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
    ])
  }

  private func bind() {
    deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    keepButton.addTarget(self, action: #selector(keepTapped), for: .touchUpInside)
  }

  @objc private func deleteTapped() { viewModel.deleteOriginalTapped() }
  @objc private func keepTapped() { viewModel.keepOriginalTapped() }
}
