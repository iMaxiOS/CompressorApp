//
//  VideoQualityViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit
import AVFoundation

final class VideoQualityViewController: UIViewController {
  
  private let viewModel: VideoQualityViewModel
  
  private let preview = PlayerView()
  private var player: AVPlayer?
  
  private lazy var nowVStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 6
    return stack
  }()
  
  private lazy var willVStack: UIStackView = {
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
  
  private lazy var nowByteLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    return label
  }()
  
  private lazy var willByteLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = #colorLiteral(red: 0.3254901961, green: 0.4117647059, blue: 0.9294117647, alpha: 1)
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    return label
  }()
  
  private lazy var willBeLabel: UILabel = {
    let label = UILabel()
    label.text = "Will be"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let low = QualityRowView(title: VideoQualityOption.low.title)
  private let medium = QualityRowView(title: VideoQualityOption.medium.title)
  private let high = QualityRowView(title: VideoQualityOption.high.title)
  
  private let compressButton = UIButton(type: .system)
  
  init(viewModel: VideoQualityViewModel) {
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
    
    [preview, nowVStack, rightIcon, willVStack, low, medium, high, compressButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
    
    var cfg = UIButton.Configuration.filled()
    cfg.title = "Compress"
    cfg.cornerStyle = .large
    cfg.baseBackgroundColor = .systemIndigo
    cfg.baseForegroundColor = .white
    cfg.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    compressButton.configuration = cfg
    
    nowVStack.addArrangedSubview(nowLabel)
    nowVStack.addArrangedSubview(nowByteLabel)
    willVStack.addArrangedSubview(willBeLabel)
    willVStack.addArrangedSubview(willByteLabel)
    
    NSLayoutConstraint.activate([
      preview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      preview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      preview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      preview.heightAnchor.constraint(equalTo: preview.widthAnchor, multiplier: 0.7),
      
      nowVStack.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 18),
      nowVStack.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: 10),
      
      rightIcon.widthAnchor.constraint(equalToConstant: 40),
      rightIcon.heightAnchor.constraint(equalToConstant: 40),
      rightIcon.centerYAnchor.constraint(equalTo: nowVStack.centerYAnchor),
      rightIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      willVStack.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 18),
      willVStack.trailingAnchor.constraint(equalTo: preview.trailingAnchor, constant: -10),
      willVStack.widthAnchor.constraint(equalToConstant: 100),
      
      low.bottomAnchor.constraint(equalTo: medium.topAnchor, constant: -10),
      low.leadingAnchor.constraint(equalTo: preview.leadingAnchor),
      low.trailingAnchor.constraint(equalTo: preview.trailingAnchor),
      low.heightAnchor.constraint(equalToConstant: 60),
      
      medium.bottomAnchor.constraint(equalTo: high.topAnchor, constant: -10),
      medium.leadingAnchor.constraint(equalTo: low.leadingAnchor),
      medium.trailingAnchor.constraint(equalTo: low.trailingAnchor),
      medium.heightAnchor.constraint(equalToConstant: 60),
      
      high.bottomAnchor.constraint(equalTo: compressButton.topAnchor, constant: -18),
      high.leadingAnchor.constraint(equalTo: low.leadingAnchor),
      high.trailingAnchor.constraint(equalTo: low.trailingAnchor),
      high.heightAnchor.constraint(equalToConstant: 60),
      
      compressButton.heightAnchor.constraint(equalToConstant: 60),
      compressButton.leadingAnchor.constraint(equalTo: preview.leadingAnchor),
      compressButton.trailingAnchor.constraint(equalTo: preview.trailingAnchor),
      compressButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
    ])
  }
  
  private func bind() {
    low.onTap = { [weak self] in
      guard let self else { return }
      self.viewModel.selectQuality(.low)
      self.select(self.low)
    }

    medium.onTap = { [weak self] in
      guard let self else { return }
      self.viewModel.selectQuality(.medium)
      self.select(self.medium)
    }

    high.onTap = { [weak self] in
      guard let self else { return }
      self.viewModel.selectQuality(.high)
      self.select(self.high)
    }
    
    viewModel.onUpdate = { [weak self] in
      self?.render()
    }

    viewModel.selectQuality(.low)
    select(low)
    render()

    
    compressButton.addTarget(self, action: #selector(compressTapped), for: .touchUpInside)
    
    viewModel.onCompress = { [weak self] in
      let vm = CompressingViewModel()
      let vc = CompressingViewController(viewModel: vm)
      self?.navigationController?.pushViewController(vc, animated: true)
    }
    
    let p = AVPlayer(url: viewModel.videoURL)
    p.isMuted = true
    self.player = p
    self.preview.player = p
    p.play()
    
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                           object: p.currentItem,
                                           queue: .main) { _ in
      p.seek(to: .zero)
      p.play()
    }
  }
  
  private func render() {
    nowByteLabel.text = "\(viewModel.originalSizeText)"
    willByteLabel.text = "\(viewModel.estimatedSizeText)"
  }

  
  private func select(_ row: QualityRowView?) {
    guard let row else { return }
    let all: [QualityRowView] = [low, medium, high]
    all.forEach { $0.setChecked($0 === row, animated: true) }
  }
  
  @objc private func compressTapped() {
    viewModel.compressTapped()
  }
  
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}


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

final class PlayerView: UIView {
  override class var layerClass: AnyClass { AVPlayerLayer.self }
  
  var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
  
  var player: AVPlayer? {
    get { playerLayer.player }
    set { playerLayer.player = newValue }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    playerLayer.videoGravity = .resizeAspectFill
    backgroundColor = .black
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

