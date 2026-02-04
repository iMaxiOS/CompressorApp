//
//  OnboardingViewController.swift
//  CompressorApp
//
//  Created by Maxim Hranchenko on 03.02.2026.
//

import UIKit

final class OnboardingViewController: UIViewController {
  
  private let viewModel: OnboardingViewModel
  
  private let layout = UICollectionViewFlowLayout()
  
  private lazy var collectionView: UICollectionView = {
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.isPagingEnabled = true
    cv.showsHorizontalScrollIndicator = false
    cv.backgroundColor = .systemBackground
    cv.dataSource = self
    cv.delegate = self
    cv.translatesAutoresizingMaskIntoConstraints = false
    
    cv.contentInsetAdjustmentBehavior = .never
    
    cv.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseId)
    return cv
  }()
  
  private let pageControl: UIPageControl = {
    let pc = UIPageControl()
    pc.currentPageIndicatorTintColor = .systemBlue
    pc.pageIndicatorTintColor = .systemGray4
    pc.isUserInteractionEnabled = false
    pc.translatesAutoresizingMaskIntoConstraints = false
    return pc
  }()
  
  private let continueButton: UIButton = {
    var cfg = UIButton.Configuration.filled()
    cfg.title = "Continue"
    cfg.cornerStyle = .large
    cfg.baseBackgroundColor = .systemBlue
    cfg.baseForegroundColor = .white
    cfg.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    let b = UIButton(configuration: cfg)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupUI()
    bind()
    
    viewModel.setIndex(0)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let size = collectionView.bounds.size
    if layout.itemSize != size {
      layout.itemSize = size
      layout.invalidateLayout()
      
      scrollTo(index: viewModel.currentIndex, animated: false)
    }
  }
  
  private func setupUI() {
    view.addSubview(collectionView)
    view.addSubview(pageControl)
    view.addSubview(continueButton)
    
    pageControl.numberOfPages = viewModel.pages.count
    
    continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
      
      pageControl.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -14),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  private func bind() {
    viewModel.onIndexChanged = { [weak self] index in
      guard let self else { return }
      self.pageControl.currentPage = index
      let title = (index == self.viewModel.pages.count - 1) ? "Start" : "Continue"
      self.continueButton.configuration?.title = title
    }
    
    viewModel.onFinish = { [weak self] in
      guard let self else { return }
      UserDefaults.standard.set(true, forKey: "isOnboarded")
      
      let main = MainViewController(viewModel: MainViewModel())
      if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
        sceneDelegate.setRoot(main, animated: true)
      }
    }
  }
  
  @objc private func didTapContinue() {
    if viewModel.isLast {
      viewModel.continueTapped()
      return
    }
    
    let next = viewModel.currentIndex + 1
    scrollTo(index: next, animated: true)
    viewModel.setIndex(next)
  }
  
  private func scrollTo(index: Int, animated: Bool) {
    guard index >= 0, index < viewModel.pages.count else { return }
    collectionView.layoutIfNeeded()
    collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                at: .centeredHorizontally,
                                animated: animated)
  }
}

// MARK: - DataSource / Delegate
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.pages.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.reuseId,
                                                  for: indexPath) as! OnboardingCell
    cell.configure(viewModel.pages[indexPath.item])
    return cell
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let page = Int(round(scrollView.contentOffset.x / max(1, scrollView.bounds.width)))
    viewModel.setIndex(page)
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    let page = Int(round(scrollView.contentOffset.x / max(1, scrollView.bounds.width)))
    viewModel.setIndex(page)
  }
}
