//
//  DemoMediaFactory.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

enum DemoMediaFactory {
  static func makeGroups(for category: MediaCategory) -> [MediaGroup] {
    func img(_ name: String) -> UIImage { UIImage(named: name) ?? UIImage() }

    let a1 = MediaAsset(id: 1, preview: img("image02"), bytes: 2_000_000, isBest: true)
    let a2 = MediaAsset(id: 2, preview: img("image02_2"), bytes: 2_500_000, isBest: false)
    let a3 = MediaAsset(id: 3, preview: img("image04"), bytes: 5_000_000, isBest: true)
    let a4 = MediaAsset(id: 4, preview: img("image04_2"), bytes: 4_000_000, isBest: false)
    let a5 = MediaAsset(id: 5, preview: img("image07"), bytes: 2_000_000, isBest: true)
    let a6 = MediaAsset(id: 6, preview: img("image07_2"), bytes: 5_000_000, isBest: false)
    let a7 = MediaAsset(id: 7, preview: img("image06"), bytes: 5_000_000, isBest: false)
    let a8 = MediaAsset(id: 8, preview: img("image03"), bytes: 4_000_000, isBest: false)
    let a9 = MediaAsset(id: 9, preview: img("image05"), bytes: 2_000_000, isBest: false)

    switch category {
    case .duplicatePhotos:
      return [
        .init(id: 1, title: "2 Duplicate", assets: [a1, a2]),
        .init(id: 2, title: "2 Duplicate", assets: [a3, a4]),
        .init(id: 3, title: "2 Duplicate", assets: [a5, a6]),
      ]
    case .similarPhotos, .similarVideos:
      return [
        .init(id: 1, title: "2 Similar", assets: [a1, a2]),
        .init(id: 2, title: "2 Similar", assets: [a3, a4]),
        .init(id: 3, title: "2 Similar", assets: [a5, a6]),
      ]
    case .screenshots:
      return [.init(id: 1, title: "Screenshots", assets: [a1, a3, a5, a7, a8, a9])]
    case .livePhotos:
      return [.init(id: 2, title: "Live Photos", assets: [a1, a3, a5, a7, a8, a9])]
    case .screenRecordings:
      return [.init(id: 3, title: "Screen Recordings", assets: [a1, a3, a5, a7, a8, a9])]
    }
  }
}
