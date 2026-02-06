//
//  VideoQualityViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import Foundation

enum VideoQualityOption: CaseIterable {
  case low
  case medium
  case high
  
  var title: String {
    switch self {
    case .low: return "Low quality"
    case .medium: return "Medium quality"
    case .high: return "High quality"
    }
  }
  
  var estimatedRatio: Double {
    switch self {
    case .low: return 0.50
    case .medium: return 0.70
    case .high: return 0.85
    }
  }
}

final class VideoQualityViewModel {
  let videoURL: URL
  let originalSizeBytes: Int64
  
  private(set) var selectedQuality: VideoQualityOption = .low
  
  var onUpdate: (() -> Void)?
  var onCompress: (() -> Void)?
  
  init(videoURL: URL, originalSizeBytes: Int64) {
    self.videoURL = videoURL
    self.originalSizeBytes = max(0, originalSizeBytes)
  }
  
  func selectQuality(_ quality: VideoQualityOption) {
    selectedQuality = quality
    onUpdate?()
  }
  
  func compressTapped() {
    onCompress?()
  }
  
  var originalSizeText: String {
    String.format(bytes: originalSizeBytes)
  }
  
  var estimatedSizeBytes: Int64 {
    Int64(Double(originalSizeBytes) * selectedQuality.estimatedRatio)
  }
  
  var estimatedSizeText: String {
    String.format(bytes: estimatedSizeBytes)
  }
}
