//
//  MainViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import UIKit

final class MainViewController: UIViewController {
  
  private let viewModel: MainViewModel
  
  private let headerView = UIView()
  private let storageTitleLabel = UILabel()
  private let storageSubtitleLabel = UILabel()
  private let ringView = RingView()
  
  private let titleVStack: UIStackView = {
    let v = UIStackView()
    v.axis = .vertical
    v.spacing = 5
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  private let imagesHStack: UIStackView = {
    let h = UIStackView()
    h.axis = .horizontal
    h.spacing = 5
    h.distribution = .fillEqually
    h.translatesAutoresizingMaskIntoConstraints = false
    return h
  }()
  
  private let cardContainer = UIView()
  private let compressorCard = SectionCardView()
  private let mediaCard = SectionCardView()
  
  private let compressorImage: UIImageView = {
    let im = UIImageView()
    im.image = UIImage(named: "disco_image")
    im.contentMode = .scaleAspectFill
    im.clipsToBounds = true
    im.layer.cornerRadius = 10
    im.translatesAutoresizingMaskIntoConstraints = false
    return im
  }()
  
  
  private let mediaThumbLeft: UIImageView = {
    let im = UIImageView()
    im.image = UIImage(named: "cat_image")
    im.contentMode = .scaleAspectFill
    im.clipsToBounds = true
    im.layer.cornerRadius = 10
    im.translatesAutoresizingMaskIntoConstraints = false
    return im
  }()
  
  private let mediaThumbRight: UIImageView = {
    let im = UIImageView()
    im.image = UIImage(named: "jiraff_image")
    im.contentMode = .scaleAspectFill
    im.clipsToBounds = true
    im.layer.cornerRadius = 10
    im.translatesAutoresizingMaskIntoConstraints = false
    return im
  }()
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.5291496515, green: 0.7021511197, blue: 0.9844933152, alpha: 1)
    setupUI()
    bind()
    setupLockTaps()
    render()
  }
  
  private func bind() {
    viewModel.onUpdate = { [weak self] in self?.render() }
    
    viewModel.onRequestPhotoAccess = { [weak self] in
      guard let self else { return }
      
      PhotoPermissionManager.requestIfNeeded(from: self) { [weak self] granted in
        guard let self else { return }
        
        if granted {
          self.viewModel.setPhotoAccess(true)
        }
      }
    }
    
    compressorCard.onTapCompressor = { [weak self] in
      guard let self else { return }
      if self.viewModel.hasPhotoAccess {
        let vm = VideoCompressorListViewModel()
        let vc = VideoCompressorListViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        self.requestPhotos()
      }
    }
    
//    mediaCard.onTapMedia = { [weak self] in
//      guard let self else { return }
//      if self.viewModel.hasPhotoAccess {
//        let vm = VideoCompressorListViewModel()
//        let vc = VideoCompressorListViewController(viewModel: vm)
//        self.navigationController?.pushViewController(vc, animated: true)
//      } else {
//        self.requestPhotos()
//      }
//    }
  }
  
  private func requestPhotos() {
    PhotoPermissionManager.requestIfNeeded(from: self) { [weak self] granted in
      guard let self else { return }
      self.viewModel.setPhotoAccess(granted)
    }
  }
  
  private func setupLockTaps() {
    compressorCard.onLockTap = { [weak self] in self?.viewModel.lockTapped() }
    mediaCard.onLockTap = { [weak self] in self?.viewModel.lockTapped() }
  }
  
  private func render() {
    headerView.backgroundColor = #colorLiteral(red: 0.5291496515, green: 0.7021511197, blue: 0.9844933152, alpha: 1)
    storageTitleLabel.text = viewModel.storage.title
    storageSubtitleLabel.text = viewModel.storage.subtitle
    ringView.progress = CGFloat(viewModel.storage.percentValue)
    
    compressorCard.configure(
      icon: UIImage(named: "video_icon"),
      title: viewModel.compressorSection.title,
      subtitle: viewModel.compressorSection.subtitle,
      isViewAllLabel: false,
      locked: viewModel.compressorSection.isLocked,
      showsChevron: false
    )
    
    mediaCard.configure(
      icon: UIImage(named: "future_icon"),
      title: viewModel.mediaSection.title,
      subtitle: viewModel.mediaSection.subtitle,
      locked: viewModel.mediaSection.isLocked,
      showsChevron: true
    )
  }
  
  private func setupUI() {
    headerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(headerView)
    
    
    storageTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    storageTitleLabel.textColor = .white
    storageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    storageSubtitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    storageSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
    storageSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    ringView.translatesAutoresizingMaskIntoConstraints = false
    
    titleVStack.addArrangedSubview(storageTitleLabel)
    titleVStack.addArrangedSubview(storageSubtitleLabel)
    
    headerView.addSubview(titleVStack)
    headerView.addSubview(ringView)
    
    cardContainer.backgroundColor = .systemBackground
    cardContainer.layer.cornerRadius = 30
    cardContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    cardContainer.layer.masksToBounds = true
    cardContainer.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(cardContainer)
    
    compressorCard.translatesAutoresizingMaskIntoConstraints = false
    mediaCard.translatesAutoresizingMaskIntoConstraints = false
    
    cardContainer.addSubview(compressorCard)
    cardContainer.addSubview(compressorImage)
    cardContainer.addSubview(mediaCard)
    cardContainer.addSubview(imagesHStack)
    
    imagesHStack.addArrangedSubview(mediaThumbLeft)
    imagesHStack.addArrangedSubview(mediaThumbRight)
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 260),
      
      titleVStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
      titleVStack.centerYAnchor.constraint(equalTo: ringView.centerYAnchor),
      
      ringView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
      ringView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      ringView.widthAnchor.constraint(equalToConstant: 148),
      ringView.heightAnchor.constraint(equalToConstant: 148),
      
      cardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      cardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      cardContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      compressorCard.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 32),
      compressorCard.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 28),
      compressorCard.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -28),
      
      compressorImage.topAnchor.constraint(equalTo: compressorCard.bottomAnchor, constant: 20),
      compressorImage.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 28),
      compressorImage.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -28),
      compressorImage.heightAnchor.constraint(equalToConstant: 155),
      
      mediaCard.topAnchor.constraint(equalTo: compressorImage.bottomAnchor, constant: 24),
      mediaCard.leadingAnchor.constraint(equalTo: compressorImage.leadingAnchor),
      mediaCard.trailingAnchor.constraint(equalTo: compressorImage.trailingAnchor),
      
      mediaThumbLeft.heightAnchor.constraint(equalToConstant: 155),
      mediaThumbRight.heightAnchor.constraint(equalToConstant: 155),
      
      imagesHStack.topAnchor.constraint(equalTo: mediaCard.bottomAnchor, constant: 20),
      imagesHStack.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -28),
      imagesHStack.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 28),
      
      imagesHStack.bottomAnchor.constraint(equalTo: cardContainer.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
