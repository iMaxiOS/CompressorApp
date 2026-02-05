//
//  MediaViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import Foundation
import UIKit

final class MediaViewModel {
  
  let items: [MediaItem]

  var onSelect: ((MediaRoute) -> Void)?

  init() {
    items = [
      .init(title: "Duplicate Photos", countText: "6 Items",
            icon: UIImage(named: "future_circle_icon"),
            route: .duplicatePhotos),

      .init(title: "Similar Photos", countText: "6 Items",
            icon: UIImage(named: "camera_circle_icon"),
            route: .similarPhotos),

      .init(title: "Screenshots", countText: "6 Items",
            icon: UIImage(named: "screenshort_circle_icon"),
            route: .screenshots),

      .init(title: "Live Photos", countText: "6 Items",
            icon: UIImage(named: "live_circle_icon"),
            route: .livePhotos),

      .init(title: "Screen Recordings", countText: "6 Items",
            icon: UIImage(named: "recording_circle_icon"),
            route: .screenRecordings),

      .init(title: "Similar Videos", countText: "6 Items",
            icon: UIImage(named: "video_circle_icon"),
            route: .similarVideos),
    ]
  }

  func didSelectItem(at index: Int) {
    guard items.indices.contains(index) else { return }
    onSelect?(items[index].route)
  }
}
