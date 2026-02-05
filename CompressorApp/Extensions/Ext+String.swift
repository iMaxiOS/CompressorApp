//
//  Ext+String.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import Foundation

extension String {
  static func format(bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useMB, .useGB]
    formatter.countStyle = .file
    return formatter.string(fromByteCount: bytes)
  }
}
