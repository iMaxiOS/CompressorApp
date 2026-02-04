//
//  RingView.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//
import UIKit

final class RingView: UIView {

    private let shadowContainer = UIView()

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let percentLabel = UILabel()
    private let usedLabel = UILabel()

    var progress: CGFloat = 0.44 {
        didSet { updateProgress() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear

        shadowContainer.backgroundColor = .clear
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shadowContainer)

        NSLayoutConstraint.activate([
            shadowContainer.topAnchor.constraint(equalTo: topAnchor),
            shadowContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        applyShadow()

        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.35).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 16
        trackLayer.lineCap = .round

        progressLayer.strokeColor = #colorLiteral(red: 0.3254901961, green: 0.4117647059, blue: 0.9294117647, alpha: 1)
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 16
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0

        shadowContainer.layer.addSublayer(trackLayer)
        shadowContainer.layer.addSublayer(progressLayer)

        percentLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        percentLabel.textColor = .white
        percentLabel.textAlignment = .center
        percentLabel.translatesAutoresizingMaskIntoConstraints = false

        usedLabel.font = .systemFont(ofSize: 13, weight: .regular)
        usedLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        usedLabel.text = "used"
        usedLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(percentLabel)
        addSubview(usedLabel)

        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -6),
            usedLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 2),
            usedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let inset: CGFloat = 10
        let rect = bounds.insetBy(dx: inset, dy: inset)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        let start = -CGFloat.pi / 2
        let end = start + 2 * CGFloat.pi

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: true
        )

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath

        updateProgress()
    }

    private func updateProgress() {
        let value = max(0, min(progress, 1))
        progressLayer.strokeEnd = value
        percentLabel.text = "\(Int(value * 100))%"
    }

    private func applyShadow() {
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOpacity = 0.18
        shadowContainer.layer.shadowRadius = 18
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadowContainer.layer.masksToBounds = false
    }
}
