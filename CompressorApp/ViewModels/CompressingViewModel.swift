//
//  CompressingViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import Foundation

final class CompressingViewModel {
  
  let videoURL: URL
  let quality: VideoQualityOption
  let originalSizeBytes: Int64

  var onProgress: ((Double) -> Void)?
  var onFinish: (() -> Void)?
  var onCancel: (() -> Void)?

  private var timer: Timer?
  private var progress: Double = 0

  init(videoURL: URL, quality: VideoQualityOption, originalSizeBytes: Int64) {
    self.videoURL = videoURL
    self.quality = quality
    self.originalSizeBytes = originalSizeBytes
  }

  var compressedSizeBytes: Int64 {
    Int64(Double(originalSizeBytes) * quality.estimatedRatio)
  }

  var originalSizeText: String { Self.format(bytes: originalSizeBytes) }
  var compressedSizeText: String { Self.format(bytes: compressedSizeBytes) }

  func start() {
    stopTimer()
    progress = 0
    onProgress?(progress)

    timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { [weak self] t in
      guard let self else { return }
      self.progress = min(1.0, self.progress + 0.01)
      self.onProgress?(self.progress)

      if self.progress >= 1.0 {
        t.invalidate()
        self.timer = nil
        self.onFinish?()
      }
    }
  }

  func cancelTapped() {
    stopTimer()
    onCancel?()
  }

  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }

  private static func format(bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useMB, .useGB]
    formatter.countStyle = .file
    return formatter.string(fromByteCount: max(0, bytes))
  }
}
