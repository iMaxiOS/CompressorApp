//
//  VideoCompressorListViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit

final class VideoCompressorListViewController: UIViewController {

  private let viewModel: VideoCompressorListViewModel

  private let viewBadge = UIView()
  private let countBadge = UILabel()
  private let imageBadge = UIImageView()
  private let hStack = UIStackView()
  private let collectionView: UICollectionView

  init(viewModel: VideoCompressorListViewModel) {
    self.viewModel = viewModel
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 14
    layout.minimumInteritemSpacing = 14
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    viewBadge.layer.shadowPath = UIBezierPath(roundedRect: viewBadge.bounds, cornerRadius: viewBadge.layer.cornerRadius).cgPath
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Video Compressor"
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
    
    viewBadge.backgroundColor = .systemBackground
    viewBadge.layer.masksToBounds = false
    viewBadge.layer.shadowColor = UIColor.black.cgColor
    viewBadge.layer.shadowRadius = 4
    viewBadge.layer.cornerRadius = 5
    viewBadge.layer.cornerCurve = .continuous
    viewBadge.layer.shadowOpacity = 0.2
    viewBadge.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    hStack.axis = .horizontal
    hStack.spacing = 8
    hStack.translatesAutoresizingMaskIntoConstraints = false
    
    imageBadge.image = UIImage(named: "video_black_icon")
    imageBadge.tintColor = .label
    
    countBadge.text = "\(viewModel.videos.count) Videos"
    countBadge.font = .systemFont(ofSize: 14, weight: .regular)
    countBadge.textColor = .secondaryLabel

    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.reuseId)
    
    [viewBadge, collectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    viewBadge.addSubview(hStack)
    hStack.addArrangedSubview(imageBadge)
    hStack.addArrangedSubview(countBadge)

    NSLayoutConstraint.activate([
      viewBadge.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
      viewBadge.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      
      hStack.topAnchor.constraint(equalTo: viewBadge.topAnchor, constant: 5),
      hStack.leadingAnchor.constraint(equalTo: viewBadge.leadingAnchor, constant: 8),
      hStack.trailingAnchor.constraint(equalTo: viewBadge.trailingAnchor, constant: -8),
      hStack.bottomAnchor.constraint(equalTo: viewBadge.bottomAnchor, constant: -5),
      
      imageBadge.heightAnchor.constraint(equalToConstant: 24),
      imageBadge.widthAnchor.constraint(equalToConstant: 24),
      
      hStack.centerXAnchor.constraint(equalTo: viewBadge.centerXAnchor),
      hStack.centerYAnchor.constraint(equalTo: viewBadge.centerYAnchor),

      collectionView.topAnchor.constraint(equalTo: viewBadge.bottomAnchor, constant: 12),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func bind() {
    viewModel.onSelectVideo = { [weak self] url, bytes in
      let vm = VideoQualityViewModel(videoURL: url, originalSizeBytes: bytes)
      let vc = VideoQualityViewController(viewModel: vm)
      self?.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension VideoCompressorListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.videos.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseId,
                                                  for: indexPath) as! VideoCell
    let url = viewModel.videos[indexPath.item]
    cell.configure(videoURL: url, sizeText: "1.2 GB")
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectVideo(at: indexPath.item)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    8
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    8
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing: CGFloat = 8
    let w = (collectionView.bounds.width - spacing) / 2
    return CGSize(width: w, height: w)
  }
}
