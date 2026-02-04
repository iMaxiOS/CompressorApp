//
//  OnboardingViewModel.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import UIKit

struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: UIImage?
}

final class OnboardingViewModel {

    let pages: [OnboardingPage] = [
        .init(title: "Clean your Storage",
              subtitle: "Pick the best & delete the rest",
              image: UIImage(named: "onb1")),
        .init(title: "Detect Similar Photos",
              subtitle: "Clean similar photos & videos, save your storage space",
              image: UIImage(named: "onb2")),
        .init(title: "Video Compressor",
              subtitle: "Find large videos and compress them to free up space",
              image: UIImage(named: "onb3"))
    ]

    private(set) var currentIndex: Int = 0

    var onIndexChanged: ((Int) -> Void)?
    var onFinish: (() -> Void)?

    var isLast: Bool { currentIndex == pages.count - 1 }

    func setIndex(_ index: Int) {
        currentIndex = max(0, min(index, pages.count - 1))
        onIndexChanged?(currentIndex)
    }

    func continueTapped() {
        if isLast {
            onFinish?()
        } else {
          setIndex(currentIndex + 1)
        }
    }
}
