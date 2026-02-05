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
      .init(title: "Duplicate Photos", countText: "1746 Items",
            icon: UIImage(systemName: "photo"), iconBackground: UIColor.systemIndigo.withAlphaComponent(0.18),
            route: .duplicatePhotos),

      .init(title: "Similar Photos", countText: "1746 Items",
            icon: UIImage(systemName: "video"), iconBackground: UIColor.systemIndigo.withAlphaComponent(0.18),
            route: .similarPhotos),

      .init(title: "Screenshots", countText: "1746 Items",
            icon: UIImage(systemName: "crop"), iconBackground: UIColor.systemIndigo.withAlphaComponent(0.18),
            route: .screenshots),

      .init(title: "Live Photos", countText: "1746 Items",
            icon: UIImage(systemName: "livephoto"), iconBackground: UIColor.systemIndigo.withAlphaComponent(0.18),
            route: .livePhotos),

      .init(title: "Screen Recordings", countText: "1746 Items",
            icon: UIImage(systemName: "rectangle.on.rectangle"), iconBackground: UIColor.systemIndigo.withAlphaComponent(0.18),
            route: .screenRecordings),

      .init(title: "Similar Videos", countText: "1746 Items",
            icon: UIImage(systemName: "video.fill"), iconBackground: UIColor.systemIndigo.withAlphaComponent(0.18),
            route: .similarVideos),
    ]
  }

  func didSelectItem(at index: Int) {
    guard items.indices.contains(index) else { return }
    onSelect?(items[index].route)
  }
}
