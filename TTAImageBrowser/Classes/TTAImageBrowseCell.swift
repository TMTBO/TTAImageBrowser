//
//  TTAImageBrowseCell.swift
//  Pods
//
//  Created by TobyoTenma on 11/04/2017.
//
//

import UIKit

class TTAImageBrowseCell: UICollectionViewCell {
    
    var item: TTAImageBrowserViewModel! {
        didSet {
            startSpinner()
            zoomView.config(from: item.thumbnailImageViewFrame, to: item.bigImageViewFrame, image: item.image, imageURLString: item.browserItem.imageURL, isFirstOpen: item.isFirstOpen)
            item.loadImage { [weak self] (image, error) in
                guard let `self` = self else { return }
                self.zoomView.config(image: image)
                self.stopSpinner()
            }
        }
    }
    
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    fileprivate let zoomView = TTAImageZoomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

// MARK: - Public method

fileprivate extension TTAImageBrowseCell {
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
}

// MARK: - LifeCycle

extension TTAImageBrowseCell {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - UI

fileprivate extension TTAImageBrowseCell {
    
    func setupUI() {
        func _addViews() {
            contentView.addSubview(zoomView)
            contentView.addSubview(spinner)
        }
        func _configViews() {
            zoomView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        _addViews()
        _configViews()
        _layoutViews()
    }
    
    func _layoutViews() {
        spinner.center = contentView.center
        zoomView.frame = contentView.bounds
    }
}
