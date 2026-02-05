//
//  MediaCategory.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

enum MediaCategory {
  case duplicatePhotos
  case similarPhotos
  case livePhotos
  case screenshots
  case screenRecordings
  case similarVideos

  var title: String {
    switch self {
    case .duplicatePhotos: return "Duplicate Photos"
    case .similarPhotos: return "Similar Photos"
    case .livePhotos: return "Live Photos"
    case .screenshots: return "Screen Photos"
    case .screenRecordings: return "Screen Recordings"
    case .similarVideos: return "Similar Videos"
    }
  }

  var itemsBadgeIcon: UIImage? {
    switch self {
    case .screenRecordings, .similarVideos:
      return UIImage(systemName: "video")
    default:
      return UIImage(systemName: "photo")
    }
  }
}

struct MediaAsset: Hashable, Identifiable {
  let id: Int
  let preview: UIImage
  let bytes: Int64
  let isBest: Bool
}

struct MediaGroup: Hashable, Identifiable {
  let id: Int
  let title: String
  var assets: [MediaAsset]
}
