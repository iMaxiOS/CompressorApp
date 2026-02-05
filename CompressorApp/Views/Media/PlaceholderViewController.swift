//
//  PlaceholderViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 05.02.2026.
//

import UIKit

final class PlaceholderViewController: UIViewController {
  private let titleText: String
  
  init(titleText: String) {
    self.titleText = titleText
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = titleText
  }
}
