//
//  ScreenType.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 06.02.2026.
//

import UIKit

enum ScreenType {
  case small
  case middle
  case large
}

extension UIScreen {
  static var screenType: ScreenType {
    let height = UIScreen.main.nativeBounds.height / UIScreen.main.scale
    
    switch height {
    case ..<700:
      return .small
    case 700..<850:
      return .middle
    default:
      return .large
    }
  }
}
