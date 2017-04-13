//
//  TTAImageBrowserViewModel.swift
//  Pods
//
//  Created by TobyoTenma on 12/04/2017.
//
//

import Foundation
import Kingfisher

public class TTAImageBrowserViewModel {
    
    fileprivate(set) var browserItem: TTABrowseItem!
    fileprivate(set) var image: UIImage?
    fileprivate(set) var thumbnailImageViewFrame: CGRect!
    fileprivate(set) var bigImageViewFrame: CGRect!
    public var isFirstOpen = false
    
    public init(imageURL: String?, thumbnailImageView: UIImageView?) {
        browserItem = TTABrowseItem(imageURL: imageURL, thumbnailImageView: thumbnailImageView)
        image = thumbnailImageView?.image
        thumbnailImageViewFrame = convertThumbnailImageViewFrame()
        bigImageViewFrame = getBigImageViewFrame()
    }
    public init(imageLocalPath: String?, thumbnailImageView: UIImageView?) {
        browserItem = TTABrowseItem(imageLocalPath: imageLocalPath, thumbnailImageView: thumbnailImageView)
        image = thumbnailImageView?.image
        thumbnailImageViewFrame = convertThumbnailImageViewFrame()
        bigImageViewFrame = getBigImageViewFrame()
    }
    public init(image: UIImage?, thumbnailImageView: UIImageView?) {
        browserItem = TTABrowseItem(image: image, thumbnailImageView: thumbnailImageView)
        self.image = image
        thumbnailImageViewFrame = convertThumbnailImageViewFrame()
        bigImageViewFrame = getBigImageViewFrame()
    }
    public init(data: Data?, thumbnailImageView: UIImageView?) {
        browserItem = TTABrowseItem(data: data, thumbnailImageView: thumbnailImageView)
        image = thumbnailImageView?.image
        thumbnailImageViewFrame = convertThumbnailImageViewFrame()
        bigImageViewFrame = getBigImageViewFrame()
    }
}

// MARK: - LoadImage
extension TTAImageBrowserViewModel {
    
    /// LoadImage
    func loadImage(_ completionHandler: ((UIImage?, NSError?) -> ())?) {
        if let urlString = browserItem.imageURL,
            let imageURL = URL(string: urlString) {
            loadImage(url: imageURL, completionHandler: completionHandler)
        } else if let imageLocalPath = browserItem.imageLocalPath {
            loadImage(localPath: imageLocalPath, completionHandler: completionHandler)
        } else if let imageData = browserItem.imageData {
            loadImage(imageData: imageData, completionHandler: completionHandler)
        } else if let image = browserItem.image {
            loadImage(image: image, completionHandler: completionHandler)
        }
    }
}

// MARK: - LoadImage

fileprivate extension TTAImageBrowserViewModel {
    
    /// LoadImage from network
    func loadImage(url: URL, completionHandler: ((UIImage?, NSError?) -> ())?) {
        if KingfisherManager.shared.cache.isImageCached(forKey: url.absoluteString).cached == false {
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, _, _) in
                self.image = image
                completionHandler?(image, error)
            }
        } else {
            KingfisherManager.shared.cache.retrieveImage(forKey: url.absoluteString, options: nil, completionHandler: { (image, cacheType) in
                self.image = image
                completionHandler?(image, nil)
            })
        }
    }
    
    /// LoadImag from Local path
    func loadImage(localPath: String, completionHandler: ((UIImage?, NSError?) -> ())?) {
        guard let image = UIImage(contentsOfFile: localPath) else { return }
        self.image = image
        completionHandler?(image, nil)
    }
    /// LoadImag from Local ImageData
    func loadImage(imageData: Data, completionHandler: ((UIImage?, NSError?) -> ())?) {
        guard let image = UIImage(data: imageData) else { return }
        self.image = image
        completionHandler?(image, nil)
    }
    /// LoadImag from Local image
    func loadImage(image: UIImage, completionHandler: ((UIImage?, NSError?) -> ())?) {
        self.image = image
        completionHandler?(image, nil)
    }
}

// MARK: - Get or Convert Frame

fileprivate extension TTAImageBrowserViewModel {
    
    func getBigImageViewFrame() -> CGRect {
        let image = browserItem.thumbnailImageView?.image
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let widthRatio = screenWidth / (image?.size.width ?? 1)
        let heightRatio = screenHeight / (image?.size.height ?? 1)
        let scale = min(widthRatio, heightRatio)
        let width = scale * (image?.size.width ?? 0)
        let height = scale * (image?.size.height ?? 0)
        return CGRect(x: (screenWidth - width) / 2, y: (screenHeight - height) / 2, width: width, height: height)
    }
    
    func convertThumbnailImageViewFrame() -> CGRect {
        guard let thumbView = browserItem.thumbnailImageView,
            let superview = thumbView.superview,
            let windowView = UIApplication.shared.delegate?.window else { // I donot know why the `UIApplication.shared.keyWindow` got `nil` here, but got the correct window in other place
            let wh: CGFloat = 0.1
            let x = (UIScreen.main.bounds.width - wh) / 2
            let y = (UIScreen.main.bounds.height - wh) / 2
            let point = CGPoint(x: x, y: y)
            let size = CGSize(width: wh, height: wh)
            let rect = CGRect(origin: point, size: size)
            return rect
        }
        return superview.convert(thumbView.frame, to: windowView)
    }
}
