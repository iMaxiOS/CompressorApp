//
//  CompressingViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import Foundation

final class CompressingViewModel {
  var onCancel: (() -> Void)?
  var onFinish: (() -> Void)?

  func cancelTapped() { onCancel?() }
  func simulateFinish() { onFinish?() }
}
