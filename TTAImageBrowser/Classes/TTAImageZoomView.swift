//
//  TTAImageZoomView.swift
//  Pods
//
//  Created by TobyoTenma on 11/04/2017.
//
//

import UIKit

class TTAImageZoomView: UIScrollView {
    
    struct TTAImageZoomViewConst {
        
        static var tips: String {
            return getLocalizableString("Tips")
        }
        static var tipMessage: String {
            return getLocalizableString("What you wanna do?")
        }
        static var saveImage: String {
            return getLocalizableString("Save Image")
        }
        static var copyImageURL: String {
            return getLocalizableString("Copy Image URL")
        }
        static var copySuccess: String {
            return getLocalizableString("Copy Success")
        }
        static var cancel: String {
            return getLocalizableString("Cancel")
        }
        static var saveSuccess: String {
            return getLocalizableString("Save Success")
        }
        static var saveFailed: String {
            return getLocalizableString("Save Failed")
        }
        
        static func getLocalizableString(_ key: String) -> String {
            guard var language = NSLocale.preferredLanguages.first else { return key }
            if language.hasPrefix("en") {
                language = "en"
            } else if language.hasPrefix("zh") {
                language = "zh-Hans"
            } else {
                language = "en"
            }
            guard let resourcePath = Bundle(for: TTAImageZoomView.self).path(forResource: "TTAImageBrowser", ofType: "bundle"),
                let resourcesBundle = Bundle(path: resourcePath),
                let resourcesPath = resourcesBundle.path(forResource: language, ofType: "lproj"),
                let bundle = Bundle(path: resourcesPath) else { return key }
            
            let value = bundle.localizedString(forKey: key, value: nil, table: nil)
            return Bundle.main.localizedString(forKey: key, value: value, table: nil)
        }
    }

    fileprivate let imageView = UIImageView()
    fileprivate var imageViewFromFrame: CGRect!
    fileprivate var imageViewToFrame: CGRect!
    fileprivate var imageURLString: String!
    
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
    public func config(from fromFrame: CGRect, to toFrame: CGRect, image: UIImage?, imageURLString: String?, isFirstOpen: Bool) {
        zoomScale = 1
        
        imageView.image = image
        imageView.frame = fromFrame
        self.imageURLString = imageURLString
        
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

// MARK: - UI

fileprivate extension TTAImageZoomView {
    func setupUI() {
        func _addViews() {
            addSubview(imageView)
        }
        func _configViews() {
            
            delegate = self
            minimumZoomScale = 0.5
            maximumZoomScale = 2
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            backgroundColor = UIColor(white: 0, alpha: 0.9)
            
            imageView.alpha = 1.0
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tap:)))
            addGestureRecognizer(tap)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureAction(doubleTap:)))
            doubleTap.numberOfTapsRequired = 2
            addGestureRecognizer(doubleTap)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(longPress:)))
            longPress.minimumPressDuration = 1
            addGestureRecognizer(longPress)
            
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
            let frame = self.convert(self.imageViewFromFrame, from: UIApplication.shared.keyWindow)
            self.imageView.frame = frame
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
    @objc func longPressGestureAction(longPress: UILongPressGestureRecognizer) {
        guard longPress.state == .began else { return }
        let sheet = UIAlertController(title: TTAImageZoomViewConst.tips, message: TTAImageZoomViewConst.tipMessage, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: TTAImageZoomViewConst.saveImage, style: .default) { [weak self] (alert) in
            guard let `self` = self else { return }
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.image(image:didFinishSavingWithError:
                contextInfo:)), nil)
        }
        sheet.addAction(saveImageAction)
        if let imageURLStr = imageURLString {
            let copyImageURLAction = UIAlertAction(title: TTAImageZoomViewConst.copyImageURL, style: .default) { (alert) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = imageURLStr
                TTAImageBrowserRemindHUD.show(TTAImageZoomViewConst.copySuccess)
            }
            sheet.addAction(copyImageURLAction)
        }
        let cancelAction = UIAlertAction(title: TTAImageZoomViewConst.cancel, style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while (topController?.presentedViewController != nil) {
            topController = topController?.presentedViewController
        }
        topController?.present(sheet, animated: true, completion: nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        if error == nil {
            TTAImageBrowserRemindHUD.show(TTAImageZoomViewConst.saveSuccess)
        } else {
            TTAImageBrowserRemindHUD.show(TTAImageZoomViewConst.saveFailed)
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
