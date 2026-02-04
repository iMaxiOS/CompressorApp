//
//  VideoFileHelper.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import Foundation

enum VideoFileHelper {
  static func formattedFileSize(for url: URL) -> String {
    let bytes = fileSize(for: url)
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useMB, .useGB]
    formatter.countStyle = .file
    return formatter.string(fromByteCount: bytes)
  }
  
  static func fileSize(for url: URL) -> Int64 {
    do {
      let values = try url.resourceValues(forKeys: [.fileSizeKey])
      return Int64(values.fileSize ?? 0)
    } catch {
      return 0
    }
  }
}
