//
//  VideoCompressionService.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import AVFoundation

enum VideoQuality {
  case low, medium, high
  
  var preset: String {
    switch self {
    case .low: return AVAssetExportPreset640x480
    case .medium: return AVAssetExportPreset1280x720
    case .high: return AVAssetExportPreset1920x1080
    }
  }
}

final class VideoCompressionService {
  
  func compress(inputURL: URL, quality: VideoQuality, outputURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
    let asset = AVAsset(url: inputURL)
    
    guard let export = AVAssetExportSession(asset: asset, presetName: quality.preset) else {
      completion(.failure(NSError(domain: "export", code: -1)))
      return
    }
    
    export.outputURL = outputURL
    export.outputFileType = .mp4
    export.shouldOptimizeForNetworkUse = true
    
    export.exportAsynchronously {
      DispatchQueue.main.async {
        switch export.status {
        case .completed:
          completion(.success(outputURL))
        case .failed, .cancelled:
          completion(.failure(export.error ?? NSError(domain: "export", code: -2)))
        default:
          break
        }
      }
    }
  }
}
