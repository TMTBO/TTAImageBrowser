//
//  TTAImageBrowserViewController.swift
//  Pods
//
//  Created by TobyoTenma on 11/04/2017.
//
//

import UIKit

public class TTAImageBrowserViewController: UICollectionViewController {

    struct TTAImageBrowserViewControllerConst {
        static let cellIdentifier = "cellIdentifier"
        static let lineSpace: CGFloat = 30
        static let pageControlHeight: CGFloat = 50
        
        static var animationTimeInterval = 0.5
    }
    
    /// The timeInterval when the image browse enter and exit
    public var animationTimeInterval: TimeInterval = 0.5 {
        didSet {
            TTAImageBrowserViewControllerConst.animationTimeInterval = 0.5
        }
    }
    
    fileprivate(set) var browserItems: [TTAImageBrowserViewModel]!
    fileprivate(set) var currentIndex = 0
    
    fileprivate let pageControl = UIPageControl()
    fileprivate var layout = UICollectionViewFlowLayout()
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.layout = layout
        super.init(collectionViewLayout: layout)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Public Method

extension TTAImageBrowserViewController {
    
    public convenience init(_ items: [TTAImageBrowserViewModel], currentIndex: Int) {
        self.init()
        items[currentIndex].isFirstOpen = true
        browserItems = items
        self.currentIndex = currentIndex
    }
    
    /// Show The ImageBrowser
    public func show(_ completionHandler: (() -> ())?) {
        let topController = UIApplication.shared.keyWindow?.rootViewController
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        topController?.present(self, animated: false, completion: completionHandler)
    }
}

// MARK: - LifeCycle

extension TTAImageBrowserViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let height = TTAImageBrowserViewControllerConst.pageControlHeight
        pageControl.frame = CGRect(x: 0, y: collectionView!.bounds.height - height, width: collectionView!.bounds.width, height: height)
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - UI

fileprivate extension TTAImageBrowserViewController {
    
    func setupUI() {
        func _addViews() {
            view.addSubview(pageControl)
        }
        func _configViews() {
            let width = UIScreen.main.bounds.width + TTAImageBrowserViewControllerConst.lineSpace
            collectionView!.frame = CGRect(x: 0, y: 0, width: width, height: UIScreen.main.bounds.height)
            collectionView!.backgroundColor = .clear
            collectionView!.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView!.showsHorizontalScrollIndicator = false
            collectionView!.showsVerticalScrollIndicator = false
            collectionView!.register(TTAImageBrowseCell.self, forCellWithReuseIdentifier: TTAImageBrowserViewControllerConst.cellIdentifier)
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.collectionView?.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    self.browserItems[self.currentIndex].isFirstOpen = false
                })
            }
            
            pageControl.currentPage = currentIndex
            pageControl.numberOfPages = browserItems.count
            pageControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        _addViews()
        _configViews()
    }
}

// MARK: - UICollectionViewDataSource

extension TTAImageBrowserViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {      
        return browserItems.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TTAImageBrowserViewControllerConst.cellIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TTAImageBrowserViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! TTAImageBrowseCell
        cell.item = browserItems[indexPath.item]
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        currentIndex = Int((offsetX + width / 2) / width)
        pageControl.currentPage = currentIndex
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension TTAImageBrowserViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
