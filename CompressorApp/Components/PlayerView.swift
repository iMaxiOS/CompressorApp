//
//  PlayerView.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 04.02.2026.
//

import AVKit

final class PlayerView: UIView {
  override class var layerClass: AnyClass { AVPlayerLayer.self }
  
  var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
  
  var player: AVPlayer? {
    get { playerLayer.player }
    set { playerLayer.player = newValue }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    playerLayer.videoGravity = .resizeAspectFill
    backgroundColor = .black
  }
  
  required init?(coder: NSCoder) { fatalError() }
}
