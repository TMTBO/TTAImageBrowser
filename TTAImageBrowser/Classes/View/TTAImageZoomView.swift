//
//  TTAImageZoomView.swift
//  Pods
//
//  Created by TobyoTenma on 11/04/2017.
//
//

import UIKit

class TTAImageZoomView: UIScrollView {

    fileprivate let imageView = UIImageView()
    fileprivate var imageViewFromFrame: CGRect!
    fileprivate var imageViewToFrame: CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

}

// MARK: - Public Method

extension TTAImageZoomView {
    
    /// Config the imageView's `image` and if it's the firstOpen then animation from `fromFram` to `toFrame`
    public func config(from fromFrame: CGRect, to toFrame: CGRect, image: UIImage?, isFirstOpen: Bool) {
        imageView.image = image
        imageView.frame = fromFrame
        imageViewFromFrame = fromFrame
        imageViewToFrame = toFrame
        guard isFirstOpen else {
            imageView.frame = toFrame
            return
        }
        let time = TTAImageBrowserViewController.TTAImageBrowserViewControllerConst.animationTimeInterval
        UIView.animate(withDuration: time) { [weak self] in
            guard let `self` = self else { return }
            self.imageView.frame = toFrame
        }
    }
    
    /// Config the imageView's `image`
    public func config(image: UIImage?) {
        imageView.image = image
    }
}

// MARK: - LifeCycle

extension TTAImageZoomView {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - UI

fileprivate extension TTAImageZoomView {
    func setupUI() {
        func _addViews() {
            addSubview(imageView)
        }
        func _configViews() {
            
            delegate = self
            minimumZoomScale = 0.5
            maximumZoomScale = 3
            backgroundColor = UIColor(white: 0, alpha: 0.9)
            
            imageView.alpha = 1.0
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tap:)))
            addGestureRecognizer(tap)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureAction(doubleTap:)))
            doubleTap.numberOfTapsRequired = 2
            addGestureRecognizer(doubleTap)
            
            // TODO: Finish the pan gesture
//            let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(pan:)))
//            pan.delegate = self
//            pan.maximumNumberOfTouches = 1
//            pan.minimumNumberOfTouches = 1
//            addGestureRecognizer(pan)
            
            tap.require(toFail: doubleTap)
        }
        func _layoutViews() {
            imageView.frame = bounds
        }
        _addViews()
        _configViews()
        _layoutViews()
    }
}

// MARK: - Actions

fileprivate extension TTAImageZoomView {
    
    @objc func tapGestureAction(tap: UITapGestureRecognizer) {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        let time = TTAImageBrowserViewController.TTAImageBrowserViewControllerConst.animationTimeInterval
        UIView.animate(withDuration: time, animations: { [weak self] in
            guard let `self` = self else { return }
            self.imageView.frame = self.imageViewFromFrame
        }) { (isFinished) in
            let topController = UIApplication.shared.keyWindow?.rootViewController
            topController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc func doubleTapGestureAction(doubleTap: UITapGestureRecognizer) {
        guard doubleTap.state == .ended else { return }
        if zoomScale > 1 {
            setZoomScale(1, animated: true)
        } else {
            let touchPoint = doubleTap.location(in: imageView)
            let width = bounds.width / maximumZoomScale
            let height = bounds.height / maximumZoomScale
            let zoomToRect = CGRect(x: touchPoint.x - width / 2, y: touchPoint.y - height / 2, width: width, height: height)
            zoom(to: zoomToRect, animated: true)
        }
    }
    @objc func panGestureAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began || pan.state == .changed {
            let point = pan.translation(in: self)
            let lineSpace = TTAImageBrowserViewController.TTAImageBrowserViewControllerConst.lineSpace
            let toCenter = CGPoint(x: imageView.center.x + point.x - lineSpace / 2, y: imageView.center.y + point.y)
            imageView.center = toCenter
            pan.setTranslation(.zero, in: self)
        } else if pan.state == .ended {
            imageView.frame = imageViewToFrame
        }
    }
}

// MARK: - UIScrollViewDelegate

extension TTAImageZoomView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = bounds.width > contentSize.width ? (bounds.width - contentSize.width) * 0.5 : 0
        let offsetY = bounds.height > contentSize.height ? (bounds.height - contentSize.height) * 0.5 : 0
        let lineSpace = TTAImageBrowserViewController.TTAImageBrowserViewControllerConst.lineSpace
        imageView.center = CGPoint(x: contentSize.width * 0.5 + offsetX - lineSpace / 2, y: contentSize.height * 0.5 + offsetY)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TTAImageZoomView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
