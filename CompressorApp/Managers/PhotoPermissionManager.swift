//
//  PhotoPermissionManager.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import Photos
import UIKit

protocol PhotoPermissionServiceProtocol {
  func requestIfNeeded(completion: @escaping (Bool) -> Void)
}

final class PhotoPermissionManager {
  
  static func requestIfNeeded(from vc: UIViewController, completion: @escaping (Bool) -> Void) {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    switch status {
    case .authorized, .limited:
      completion(true)
      
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
        DispatchQueue.main.async {
          completion(newStatus == .authorized || newStatus == .limited)
        }
      }
      
    case .denied, .restricted:
      DispatchQueue.main.async {
        completion(false)
        showSettingsAlert(from: vc)
      }
      
    @unknown default:
      completion(false)
    }
  }
  
  private static func showSettingsAlert(from vc: UIViewController) {
    let alert = UIAlertController(
      title: "Photos access is disabled",
      message: "Enable access in Settings to continue.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url)
    })
    vc.present(alert, animated: true)
  }
}
