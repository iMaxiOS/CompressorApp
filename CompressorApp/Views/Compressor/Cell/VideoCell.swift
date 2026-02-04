//
//  VideoCell.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import UIKit
import AVFoundation

final class VideoCell: UICollectionViewCell {
  static let reuseId = "VideoCell"

  private let previewImageView = UIImageView()
  private let badge = UILabel()

  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?

  private var currentURL: URL?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) { fatalError() }

  override func prepareForReuse() {
    super.prepareForReuse()
    currentURL = nil
    previewImageView.image = nil
    badge.text = nil

    playerLayer?.removeFromSuperlayer()
    playerLayer = nil
    player = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer?.frame = contentView.bounds
  }

  private func setupUI() {
    contentView.layer.cornerRadius = 10
    contentView.layer.masksToBounds = true
    contentView.backgroundColor = .systemGray5

    previewImageView.contentMode = .scaleAspectFill
    previewImageView.clipsToBounds = true
    previewImageView.translatesAutoresizingMaskIntoConstraints = false

    badge.font = .systemFont(ofSize: 14, weight: .regular)
    badge.textColor = .white
    badge.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.4117647059, blue: 0.9294117647, alpha: 1)
    badge.layer.cornerRadius = 5
    badge.layer.masksToBounds = true
    badge.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(previewImageView)
    contentView.addSubview(badge)

    NSLayoutConstraint.activate([
      previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      previewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      badge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      badge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      badge.heightAnchor.constraint(equalToConstant: 24)
    ])
  }

  func configure(videoURL: URL, sizeText: String) {
    currentURL = videoURL
    badge.text = " \(VideoFileHelper.formattedFileSize(for: videoURL)) "

    if let image = Self.makeThumbnail(for: videoURL, atSeconds: 0.0) {
      previewImageView.image = image
    } else {
      previewImageView.image = nil
      previewImageView.backgroundColor = .systemGray4
    }
  }

  static func makeThumbnail(for url: URL, atSeconds: Double) -> UIImage? {
    let asset = AVAsset(url: url)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    generator.maximumSize = CGSize(width: 600, height: 600)

    let time = CMTime(seconds: max(0, atSeconds), preferredTimescale: 600)
    do {
      let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
      return UIImage(cgImage: cgImage)
    } catch {
      return nil
    }
  }
}
