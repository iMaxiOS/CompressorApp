//
//  CompressingViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//
import UIKit

final class CompressingViewController: UIViewController {
  
  private let viewModel: CompressingViewModel
  
  private let spinner = UIActivityIndicatorView(style: .large)
  private let percentLabel = UILabel()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
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
    view.backgroundColor = #colorLiteral(red: 0.5291496515, green: 0.7021511197, blue: 0.9844933152, alpha: 1)
    
    spinner.color = .white
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.startAnimating()
    
    percentLabel.font = .systemFont(ofSize: 24, weight: .semibold)
    percentLabel.textColor = .systemBackground
    percentLabel.text = "0%"
    percentLabel.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
    titleLabel.textColor = .systemBackground
    titleLabel.text = "Compressing Video ..."
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    subtitleLabel.textColor = .systemBackground
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0
    subtitleLabel.text = "Please don't close the app in order\nnot to lose all progress"
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    var cfg = UIButton.Configuration.filled()
    cfg.title = "Cancel"
    cfg.cornerStyle = .large
    cfg.baseBackgroundColor = #colorLiteral(red: 0.3249999881, green: 0.4120000005, blue: 0.92900002, alpha: 1)
    cfg.baseForegroundColor = .white
    cancelButton.configuration = cfg
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(spinner)
    view.addSubview(percentLabel)
    view.addSubview(titleLabel)
    view.addSubview(subtitleLabel)
    view.addSubview(cancelButton)
    
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -110),
      
      percentLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 16),
      percentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      titleLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 10),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      subtitleLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -24),
      subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      
      cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      cancelButton.heightAnchor.constraint(equalToConstant: 60),
    ])
  }
  
  private func bind() {
    cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    
    viewModel.onProgress = { [weak self] progress in
      let percent = Int(progress * 100)
      self?.percentLabel.text = "\(percent)%"
    }
    
    viewModel.onCancel = { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    
    viewModel.onFinish = { [weak self] in
      guard let self else { return }
      
      let vm = PreviewAfterCompressViewModel(
        videoURL: self.viewModel.videoURL,
        oldSizeBytes: self.viewModel.originalSizeBytes,
        newSizeBytes: self.viewModel.compressedSizeBytes
      )
      let vc = PreviewAfterCompressViewController(viewModel: vm)
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    viewModel.start()
  }
  
  @objc private func cancelTapped() {
    viewModel.cancelTapped()
  }
}
