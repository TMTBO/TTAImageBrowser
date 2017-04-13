//
//  TTABrowseItem.swift
//  Pods
//
//  Created by TobyoTenma on 11/04/2017.
//
//

import UIKit

struct TTABrowseItem {
    
    /// The image URL load from Net
    private(set) var imageURL: String?
    /// The image path in local
    private(set) var imageLocalPath: String?
    private(set) var imageData: Data?
    private(set) var image: UIImage?
    
    private(set) var thumbnailImageView: UIImageView?
    
    init() {
        
    }
    init(imageURL: String?, thumbnailImageView: UIImageView?) {
        self.imageURL = imageURL
        self.thumbnailImageView = thumbnailImageView
    }
    init(imageLocalPath: String?, thumbnailImageView: UIImageView?) {
        self.imageLocalPath = imageLocalPath
        self.thumbnailImageView = thumbnailImageView
    }
    init(image: UIImage?, thumbnailImageView: UIImageView?) {
        self.image = image
        self.thumbnailImageView = thumbnailImageView
    }
    init(data: Data?, thumbnailImageView: UIImageView?) {
        self.imageData = data
        self.thumbnailImageView = thumbnailImageView
    }
}
