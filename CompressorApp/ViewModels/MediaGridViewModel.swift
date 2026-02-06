//
//  MediaGridViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import Foundation

final class MediaGridViewModel {

  let category: MediaCategory
  private(set) var groups: [MediaGroup]

  private var selected: Set<Int> = []

  var onUpdate: (() -> Void)?
  var onRequestDeleteConfirm: ((_ selectedCount: Int, _ selectedBytes: Int64) -> Void)?
  var onDeleteConfirmed: (() -> Void)?

  init(category: MediaCategory, groups: [MediaGroup]) {
    self.category = category
    self.groups = groups
  }

  var itemsCountText: String {
    let count = groups.reduce(0) { $0 + $1.assets.count }
    let suffix = (category == .screenRecordings || category == .similarVideos) ? "Videos" : "Photos"
    return "\(count) \(suffix)"
  }

  var saveText: String {
    let bytes = selectedBytes
    if bytes == 0 { return "0 MB" }
    return String.format(bytes: bytes)
  }

  var selectedCount: Int { selected.count }
  var selectedBytes: Int64 {
    var sum: Int64 = 0
    for group in groups {
      for a in group.assets where selected.contains(a.id) {
        sum += a.bytes
      }
    }
    return sum
  }

  var deleteButtonTitle: String {
    let count = selectedCount
    if count == 0 { return "Delete" }
    return "Delete \(count) photos (\(String.format(bytes: selectedBytes)))"
  }

  func isSelected(_ asset: MediaAsset) -> Bool { selected.contains(asset.id) }

  // MARK: - Actions
  func toggle(asset: MediaAsset) {
    if selected.contains(asset.id) { selected.remove(asset.id) }
    else { selected.insert(asset.id) }
    onUpdate?()
  }

  func selectAll(in groupIndex: Int) {
    guard groups.indices.contains(groupIndex) else { return }
    groups[groupIndex].assets.forEach { selected.insert($0.id) }
    onUpdate?()
  }

  func deselectAll(in groupIndex: Int) {
    guard groups.indices.contains(groupIndex) else { return }
    groups[groupIndex].assets.forEach { selected.remove($0.id) }
    onUpdate?()
  }

  func isAllSelected(in groupIndex: Int) -> Bool {
    guard groups.indices.contains(groupIndex) else { return false }
    let ids = groups[groupIndex].assets.map(\.id)
    return !ids.isEmpty && ids.allSatisfy { selected.contains($0) }
  }

  func deleteTapped() {
    let count = selectedCount
    guard count > 0 else { return }
    onRequestDeleteConfirm?(count, selectedBytes)
  }

  func confirmDelete() {
    groups = groups.map { group in
      var g2 = group
      g2.assets.removeAll { selected.contains($0.id) }
      return g2
    }.filter { !$0.assets.isEmpty }

    selected.removeAll()
    onDeleteConfirmed?()
    onUpdate?()
  }
}
