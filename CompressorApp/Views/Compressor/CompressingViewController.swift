//
//  CompressingViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit

final class CompressingViewController: UIViewController {

  private let viewModel: CompressingViewModel

  private let spinner = UIActivityIndicatorView(style: .medium)
  private let percentLabel = UILabel()
  private let titleLabel = UILabel()
  private let hintLabel = UILabel()
  private let cancelButton = UIButton(type: .system)

  init(viewModel: CompressingViewModel) {
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
    view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.55)
    navigationItem.title = "Compressing your video"

    spinner.startAnimating()
    spinner.translatesAutoresizingMaskIntoConstraints = false

    percentLabel.text = "44%"
    percentLabel.font = .systemFont(ofSize: 22, weight: .bold)
    percentLabel.textColor = .white
    percentLabel.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.text = "Compressing Video ..."
    titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    titleLabel.textColor = .white
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    hintLabel.text = "Please don't close the app in order\nnot to lose all progress"
    hintLabel.textAlignment = .center
    hintLabel.numberOfLines = 2
    hintLabel.font = .systemFont(ofSize: 13)
    hintLabel.textColor = UIColor.white.withAlphaComponent(0.8)
    hintLabel.translatesAutoresizingMaskIntoConstraints = false

    var cfg = UIButton.Configuration.filled()
    cfg.title = "Cancel"
    cfg.cornerStyle = .large
    cfg.baseBackgroundColor = .systemIndigo
    cfg.baseForegroundColor = .white
    cfg.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    cancelButton.configuration = cfg
    cancelButton.translatesAutoresizingMaskIntoConstraints = false

    [spinner, percentLabel, titleLabel, hintLabel, cancelButton].forEach(view.addSubview)

    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

      percentLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 10),
      percentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      titleLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 10),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      hintLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
      hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
    ])
  }

  private func bind() {
    cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

    viewModel.onCancel = { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }

    viewModel.onFinish = { [weak self] in
      let vm = PreviewAfterCompressViewModel()
      let vc = PreviewAfterCompressViewController(viewModel: vm)
      self?.navigationController?.pushViewController(vc, animated: true)
    }

    // заглушка: авто-переход
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
      self?.viewModel.simulateFinish()
    }
  }

  @objc private func cancelTapped() {
    viewModel.cancelTapped()
  }
}
