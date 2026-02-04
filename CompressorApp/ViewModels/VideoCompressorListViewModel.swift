//
//  VideoCompressorListViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//
import Foundation

final class VideoCompressorListViewModel {
  
  let videos: [URL]
  
  var onSelectVideo: ((URL, Int64) -> Void)?
  
  init() {
    self.videos = Self.loadVideosFromBundle()
  }
  
  func didSelectVideo(at index: Int) {
    guard index >= 0, index < videos.count else { return }
    let url = videos[index]
    onSelectVideo?(url, Self.fileSizeBytes(for: url))
  }
  
  private static func loadVideosFromBundle() -> [URL] {
    let names = [
      "video",
      "video02",
      "video03",
      "video04",
    ]
    
    return names.compactMap { name in
      if let url = Bundle.main.url(forResource: name, withExtension: "mp4") { return url }
      if let url = Bundle.main.url(forResource: name, withExtension: "mov") { return url }
      
      return nil
    }
  }
  
  private static func fileSizeBytes(for url: URL) -> Int64 {
    do {
      let values = try url.resourceValues(forKeys: [.fileSizeKey])
      return Int64(values.fileSize ?? 0)
    } catch {
      return 0
    }
  }
}
