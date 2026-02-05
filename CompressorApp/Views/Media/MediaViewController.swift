//
//  MediaViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class MediaViewController: UIViewController {

  private let viewModel: MediaViewModel
  private let collectionView: UICollectionView

  init(viewModel: MediaViewModel) {
    self.viewModel = viewModel

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 8
    layout.sectionInset = UIEdgeInsets(top: 18, left: 16, bottom: 16, right: 16)

    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    title = "Media"
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true

    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.reuseId)
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func bind() {
    viewModel.onSelect = { [weak self] route in
      guard let self else { return }

      let vc: UIViewController

      switch route {
      case .duplicatePhotos:
        vc = PlaceholderViewController(titleText: "Duplicate Photos")
      case .similarPhotos:
        vc = PlaceholderViewController(titleText: "Similar Photos")
      case .screenshots:
        vc = PlaceholderViewController(titleText: "Screenshots")
      case .livePhotos:
        vc = PlaceholderViewController(titleText: "Live Photos")
      case .screenRecordings:
        vc = PlaceholderViewController(titleText: "Screen Recordings")
      case .similarVideos:
        vc = PlaceholderViewController(titleText: "Similar Videos")
      }

      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension MediaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.items.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: MediaItemCell.reuseId,
      for: indexPath
    ) as! MediaItemCell
    cell.configure(viewModel.items[indexPath.item])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItem(at: indexPath.item)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let insets = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    let spacing: CGFloat = 8
    let total = insets.left + insets.right + spacing
    let width = (collectionView.bounds.width - total) / 2
    return CGSize(width: width, height: 140)
  }
}
