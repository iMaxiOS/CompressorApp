//
//  MediaGridViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class MediaGridViewController: UIViewController {
  
  private let viewModel: MediaGridViewModel
  
  private let viewBadge = UIView()
  private let imageBadge = UIImageView()
  private let countBadge = UILabel()
  private let hStack = UIStackView()
  
  private let duplicateViewBadge = UIView()
  private let duplicateImageBadge = UIImageView()
  private let duplicateCountBadge = UILabel()
  private let duplicateHStack = UIStackView()
  
  private let collectionView: UICollectionView
  private let bottomButton = UIButton(type: .system)
  
  init(viewModel: MediaGridViewModel) {
    self.viewModel = viewModel
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    super.init(nibName: nil, bundle: nil)
    self.collectionView.setCollectionViewLayout(makeLayout(), animated: false)
  }
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    viewBadge.layer.shadowPath = UIBezierPath(roundedRect: viewBadge.bounds, cornerRadius: viewBadge.layer.cornerRadius).cgPath
    duplicateViewBadge.layer.shadowPath = UIBezierPath(roundedRect: duplicateViewBadge.bounds,
                                                       cornerRadius: duplicateViewBadge.layer.cornerRadius).cgPath
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = viewModel.category.title
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
    
    duplicateViewBadge.backgroundColor = .systemBackground
    duplicateViewBadge.layer.masksToBounds = false
    duplicateViewBadge.layer.shadowColor = UIColor.black.cgColor
    duplicateViewBadge.layer.shadowRadius = 4
    duplicateViewBadge.layer.cornerRadius = 5
    duplicateViewBadge.layer.cornerCurve = .continuous
    duplicateViewBadge.layer.shadowOpacity = 0.2
    duplicateViewBadge.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    hStack.axis = .horizontal
    hStack.spacing = 8
    hStack.translatesAutoresizingMaskIntoConstraints = false
    
    duplicateHStack.axis = .horizontal
    duplicateHStack.spacing = 8
    duplicateHStack.translatesAutoresizingMaskIntoConstraints = false
    
    imageBadge.image = UIImage(named: "video_black_icon")
    duplicateImageBadge.image = UIImage(named: "duplicate_icon")
    
    countBadge.font = .systemFont(ofSize: 14, weight: .regular)
    countBadge.textColor = .secondaryLabel
    
    duplicateCountBadge.font = .systemFont(ofSize: 14, weight: .regular)
    duplicateCountBadge.textColor = .secondaryLabel
    
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.allowsMultipleSelection = true
    collectionView.register(MediaAssetCell.self, forCellWithReuseIdentifier: MediaAssetCell.reuseId)
    collectionView.register(MediaGroupHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: MediaGroupHeaderView.reuseId)
    
    var cfg = UIButton.Configuration.filled()
    cfg.cornerStyle = .large
    cfg.baseBackgroundColor = .systemIndigo
    cfg.baseForegroundColor = .white
    cfg.contentInsets = .init(top: 14, leading: 16, bottom: 14, trailing: 16)
    bottomButton.configuration = cfg
    bottomButton.translatesAutoresizingMaskIntoConstraints = false
    bottomButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    
    [viewBadge, collectionView, duplicateViewBadge].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
    
    viewBadge.addSubview(hStack)
    hStack.addArrangedSubview(imageBadge)
    hStack.addArrangedSubview(countBadge)
    duplicateViewBadge.addSubview(duplicateHStack)
    duplicateHStack.addArrangedSubview(duplicateImageBadge)
    duplicateHStack.addArrangedSubview(duplicateCountBadge)
    view.addSubview(collectionView)
    view.addSubview(bottomButton)
    
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
      
      duplicateViewBadge.leadingAnchor.constraint(equalTo: viewBadge.trailingAnchor, constant: 10),
      duplicateViewBadge.centerYAnchor.constraint(equalTo: viewBadge.centerYAnchor),
      
      duplicateHStack.topAnchor.constraint(equalTo: duplicateViewBadge.topAnchor, constant: 5),
      duplicateHStack.leadingAnchor.constraint(equalTo: duplicateViewBadge.leadingAnchor, constant: 8),
      duplicateHStack.trailingAnchor.constraint(equalTo: duplicateViewBadge.trailingAnchor, constant: -8),
      duplicateHStack.bottomAnchor.constraint(equalTo: duplicateViewBadge.bottomAnchor, constant: -5),
      
      duplicateImageBadge.heightAnchor.constraint(equalToConstant: 24),
      duplicateImageBadge.widthAnchor.constraint(equalToConstant: 24),
      
      duplicateHStack.centerXAnchor.constraint(equalTo: duplicateViewBadge.centerXAnchor),
      duplicateHStack.centerYAnchor.constraint(equalTo: duplicateViewBadge.centerYAnchor),
      
      collectionView.topAnchor.constraint(equalTo: viewBadge.bottomAnchor, constant: 10),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      collectionView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -12),
      
      bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      bottomButton.heightAnchor.constraint(equalToConstant: 46),
    ])
    
    render()
  }
  
  private func bind() {
    viewModel.onUpdate = { [weak self] in
      self?.render()
      self?.collectionView.reloadData()
    }
    
    viewModel.onRequestDeleteConfirm = { [weak self] count, bytes in
      guard let self else { return }
      let msg = "You can restore them later from your gallery if needed."
      let alert = UIAlertController(title: "\"CompressorApp\" wants to delete photos",
                                    message: msg,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
        self.viewModel.confirmDelete()
      })
      self.present(alert, animated: true)
    }
  }
  
  private func render() {
    countBadge.text = viewModel.itemsCountText
    duplicateCountBadge.text = viewModel.saveText
    bottomButton.configuration?.title = viewModel.deleteButtonTitle
    bottomButton.isEnabled = viewModel.selectedCount > 0
    bottomButton.alpha = bottomButton.isEnabled ? 1 : 0.55
  }
  
  @objc private func deleteTapped() {
    viewModel.deleteTapped()
  }
  
  private func makeLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                          heightDimension: .fractionalWidth(0.6))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .estimated(300))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
    let section = NSCollectionLayoutSection(group: group)
    
    switch viewModel.category {
    case .livePhotos, .screenshots, .screenRecordings:
      break
    default:
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(34))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                               elementKind: UICollectionView.elementKindSectionHeader,
                                                               alignment: .top)
      section.boundarySupplementaryItems = [header]
    }
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

extension MediaGridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel.groups.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.groups[section].assets.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaAssetCell.reuseId,
                                                  for: indexPath) as! MediaAssetCell
    let asset = viewModel.groups[indexPath.section].assets[indexPath.item]
    cell.configure(asset: asset, isSelected: viewModel.isSelected(asset))
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let asset = viewModel.groups[indexPath.section].assets[indexPath.item]
    viewModel.toggle(asset: asset)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                 withReuseIdentifier: MediaGroupHeaderView.reuseId,
                                                                 for: indexPath) as! MediaGroupHeaderView
    
    
    let section = indexPath.section
    header.titleLabel.text = viewModel.groups[section].title
    
    switch viewModel.category {
    case .livePhotos, .screenshots, .screenRecordings:
      header.isHidden = true
    default:
      let allSelected = viewModel.isAllSelected(in: section)
      header.actionButton.setTitle(allSelected ? "Deselect All" : "Select All", for: .normal)
    }
    
    header.onTap = { [weak self] in
      guard let self else { return }
      if self.viewModel.isAllSelected(in: section) {
        self.viewModel.deselectAll(in: section)
      } else {
        self.viewModel.selectAll(in: section)
      }
    }
    
    return header
  }
}
