//
//  MainViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import Foundation

final class MainViewModel {
  
  var onRequestPhotoAccess: (() -> Void)?
  var onUpdate: (() -> Void)?
  var onOpenSettings: (() -> Void)?
  var onOpenCompressor: (() -> Void)?
  var onOpenMedia: (() -> Void)?
  
  private(set) var hasPhotoAccess: Bool = false
  private(set) var storage: MainStorageViewData
  private(set) var compressorSection: MainSectionViewData
  private(set) var mediaSection: MainSectionViewData
  
  init(hasPhotoAccess: Bool = false) {
    self.hasPhotoAccess = hasPhotoAccess
    
    self.storage = .init(
      title: "iPhone Storage",
      subtitle: "28.7 GB of 128.0 GB",
      percentText: "44%",
      percentValue: 0.44
    )
    
    self.compressorSection = .init(
      title: "Video Compressor",
      subtitle: "12267 Media • 54.7 GB",
      isLocked: !hasPhotoAccess
    )
    
    self.mediaSection = .init(
      title: "Media",
      subtitle: "12267 Media • 54.7 GB",
      isLocked: !hasPhotoAccess
    )
  }
  
  func setPhotoAccess(_ granted: Bool) {
    hasPhotoAccess = granted
    
    compressorSection = .init(title: compressorSection.title,
                              subtitle: compressorSection.subtitle,
                              isLocked: !granted)
    
    mediaSection = .init(title: mediaSection.title,
                         subtitle: mediaSection.subtitle,
                         isLocked: !granted)
    onUpdate?()
  }
  
  func lockTapped() {
    onRequestPhotoAccess?()
  }
}

