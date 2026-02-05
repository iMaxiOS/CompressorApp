//
//  MediaItem.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

enum MediaRoute {
  case duplicatePhotos
  case similarPhotos
  case screenshots
  case livePhotos
  case screenRecordings
  case similarVideos
}

struct MediaItem: Hashable {
  let title: String
  let countText: String
  let icon: UIImage?
  let route: MediaRoute
}
