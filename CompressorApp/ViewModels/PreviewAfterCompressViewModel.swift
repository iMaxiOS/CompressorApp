//
//  PreviewAfterCompressViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import Foundation

final class PreviewAfterCompressViewModel {

  let videoURL: URL
  let oldSizeBytes: Int64
  let newSizeBytes: Int64

  var onKeepOriginal: (() -> Void)?
  var onDeleteOriginal: (() -> Void)?

  init(videoURL: URL, oldSizeBytes: Int64, newSizeBytes: Int64) {
    self.videoURL = videoURL
    self.oldSizeBytes = max(0, oldSizeBytes)
    self.newSizeBytes = max(0, newSizeBytes)
  }

  var oldSizeText: String { Self.format(bytes: oldSizeBytes) }
  var newSizeText: String { Self.format(bytes: newSizeBytes) }

  func keepTapped() { onKeepOriginal?() }
  func deleteTapped() { onDeleteOriginal?() }

  private static func format(bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useMB, .useGB]
    formatter.countStyle = .file
    return formatter.string(fromByteCount: bytes)
  }
}
