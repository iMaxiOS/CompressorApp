//
//  PreviewAfterCompressViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit
import AVFoundation

final class PreviewAfterCompressViewController: UIViewController {

  private let viewModel: PreviewAfterCompressViewModel

  private let preview = PlayerView()
  private var player: AVPlayer?
  
  private lazy var oldSizeVStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 6
    return stack
  }()
  
  private lazy var nowVStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 6
    return stack
  }()
  
  private lazy var rightIcon: UIImageView = {
    let im = UIImageView()
    im.image = UIImage(named: "double_right_icon")
    im.contentMode = .scaleAspectFit
    return im
  }()
  
  private lazy var nowLabel: UILabel = {
    let label = UILabel()
    label.text = "Now"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var oldSizeLabel: UILabel = {
    let label = UILabel()
    label.text = "Old Size"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var nowByteLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.3249999881, green: 0.4120000005, blue: 0.92900002, alpha: 1)
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    return label
  }()
  
  private lazy var oldByteLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    return label
  }()
  
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

    preview.layer.cornerRadius = 16
    preview.layer.masksToBounds = true
    
    [preview, nowVStack, rightIcon, oldSizeVStack, keepButton, deleteButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    deleteButton.setTitle("Delete Original Video", for: .normal)
    deleteButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

    var keepCfg = UIButton.Configuration.filled()
    keepCfg.title = "Keep Original Video"
    keepCfg.cornerStyle = .large
    keepCfg.baseBackgroundColor = #colorLiteral(red: 0.3249999881, green: 0.4120000005, blue: 0.92900002, alpha: 1)
    keepCfg.baseForegroundColor = .white
    keepCfg.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    keepButton.configuration = keepCfg

    view.addSubview(preview)
    view.addSubview(oldSizeVStack)
    view.addSubview(rightIcon)
    view.addSubview(nowVStack)
    oldSizeVStack.addArrangedSubview(oldSizeLabel)
    oldSizeVStack.addArrangedSubview(oldByteLabel)
    nowVStack.addArrangedSubview(nowLabel)
    nowVStack.addArrangedSubview(nowByteLabel)
    view.addSubview(deleteButton)
    view.addSubview(keepButton)

    NSLayoutConstraint.activate([
      preview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      preview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      preview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      preview.heightAnchor.constraint(equalTo: preview.widthAnchor, multiplier: 1),
      
      oldSizeVStack.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 18),
      oldSizeVStack.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: 10),
      
      rightIcon.widthAnchor.constraint(equalToConstant: 40),
      rightIcon.heightAnchor.constraint(equalToConstant: 40),
      rightIcon.centerYAnchor.constraint(equalTo: oldSizeVStack.centerYAnchor),
      rightIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      nowVStack.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 18),
      nowVStack.trailingAnchor.constraint(equalTo: preview.trailingAnchor, constant: -10),

      deleteButton.bottomAnchor.constraint(equalTo: keepButton.topAnchor, constant: -16),
      deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      keepButton.leadingAnchor.constraint(equalTo: preview.leadingAnchor),
      keepButton.trailingAnchor.constraint(equalTo: preview.trailingAnchor),
      keepButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      keepButton.heightAnchor.constraint(equalToConstant: 60),
    ])
  }

  private func bind() {
    oldByteLabel.text = viewModel.oldSizeText
    nowByteLabel.text = viewModel.newSizeText

    deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    keepButton.addTarget(self, action: #selector(keepTapped), for: .touchUpInside)

    viewModel.onKeepOriginal = { [weak self] in
      self?.navigationController?.popToRootViewController(animated: true)
    }

    viewModel.onDeleteOriginal = { [weak self] in
      self?.navigationController?.popToRootViewController(animated: true)
    }

    let p = AVPlayer(url: viewModel.videoURL)
    p.isMuted = true
    player = p
    preview.player = p
    p.play()

    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                          object: p.currentItem,
                                          queue: .main) { _ in
      p.seek(to: .zero)
      p.play()
    }
  }

  @objc private func keepTapped() {
    viewModel.keepTapped()
  }

  @objc private func deleteTapped() {
    let alert = UIAlertController(
      title: "Delete original video?",
      message: "You can’t undo this action.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
      self?.viewModel.deleteTapped()
    })
    present(alert, animated: true)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
