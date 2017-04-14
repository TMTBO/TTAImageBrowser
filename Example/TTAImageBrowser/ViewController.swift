//
//  ViewController.swift
//  TTAImageBrowser
//
//  Created by TMTBO on 04/11/2017.
//  Copyright (c) 2017 TMTBO. All rights reserved.
//


import UIKit
import TTAImageBrowser

class ViewController: UIViewController {
    
    struct ViewControllerConst {
        static let imageViewBaseTag = 10000
        
        /// Image URLs
        static let imageURLs = [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521519&di=f8efc9f875a3a225fd9bf1d2cd50fa86&imgtype=jpg&er=1&src=http%3A%2F%2Fmvimg2.meitudata.com%2F55be4423b469a1024.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521538&di=2a461e943f531ebbc3f6ed7574b55cb9&imgtype=jpg&er=1&src=http%3A%2F%2Fmvimg1.meitudata.com%2F55d940244284e9219.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521594&di=2237b30c2921482771ec1eeaf6b5a89a&imgtype=jpg&er=1&src=http%3A%2F%2Fmvimg1.meitudata.com%2F56225386b82283819.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521618&di=1ffe43c26f1ed34932aebdb1bac2e33a&imgtype=jpg&er=1&src=http%3A%2F%2Fmvimg2.meitudata.com%2F563f173262ef26020.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521637&di=4566ba86b295057cd02cf3461630c151&imgtype=jpg&er=1&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201605%2F19%2F20160519224441_VfMWR.thumb.700_0.jpeg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492576414&di=9add16ed21305466145eff420d7f8ff4&imgtype=jpg&er=1&src=http%3A%2F%2Fmvimg1.meitudata.com%2F55e6d035533f38001.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521354&di=5856cba2145b95fee8cd658d56b4bf98&imgtype=jpg&er=1&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201601%2F04%2F20160104145421_Ld8fy.thumb.700_0.jpeg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521442&di=02a29bd30af13bf9af0c18d0d471ef00&imgtype=jpg&er=1&src=http%3A%2F%2Fimg1.windmsn.com%2Fb%2F2%2F234%2F23417%2F2341714.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492521467&di=98baf5a706d744f77899149f7eb1d25b&imgtype=jpg&er=1&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F0eb30f2442a7d9334f268ca9a84bd11372f00159.jpg"
            ]
    }
    
    /// Item group
    var groups = [[TTAImageBrowserViewModel]]()
    /// ImageViews group
    /// Actaully these imageViews can be collection view too
    @IBOutlet var imageViews: [UIImageView]!

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var toastSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        
        // Get The Items in 4 different way
        getBrowseURLItems()
        getBrowsePathItems()
        getBrowseDataItems()
        getBrowseImageItems()
        
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.value = Float(currentValue)
    }
    
    var currentValue: Int = 0
    func sliderValueChanged() {
        currentValue = Int(slider.value)
        slider.setValue(Float(currentValue), animated: true)
    }

}

extension ViewController {
    
    func addTapGesture() {
        _ = imageViews.enumerated().map { (item) -> () in
            let tap = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
            item.element.isUserInteractionEnabled = true
            item.element.tag = ViewControllerConst.imageViewBaseTag + item.offset
            item.element.addGestureRecognizer(tap)
        }
    }
    
    /// Get the item which has url
    func getBrowseURLItems() {
        let urlitems = imageViews.enumerated().map { (item) -> TTAImageBrowserViewModel in
            /// thumbnailImageView is the imageView with the imageURL
            return TTAImageBrowserViewModel(imageURL: ViewControllerConst.imageURLs[item.offset], thumbnailImageView: item.element)
        }
        groups.append(urlitems)
    }
    /// Get the item which has local image path
    func getBrowsePathItems() {
        guard let bundlePath = Bundle.main.path(forResource: "Images", ofType: "bundle") else { return }
        let pathitems = imageViews.enumerated().map { (item) -> TTAImageBrowserViewModel in
            let imageName = "/image_\(item.offset).jpeg"
            /// thumbnailImageView is the imageView with the imageLocalPath
            return TTAImageBrowserViewModel(imageLocalPath: bundlePath.appending(imageName), thumbnailImageView: item.element)
        }
        groups.append(pathitems)
    }
    /// Get the item which has image data
    func getBrowseDataItems() {
        let dataitems = imageViews.enumerated().map { (item) -> TTAImageBrowserViewModel in
            /// thumbnailImageView is the imageView with the image data
            return TTAImageBrowserViewModel(data: UIImageJPEGRepresentation(item.element.image!, 1)!, thumbnailImageView: item.element)
        }
        groups.append(dataitems)
    }
    /// Get the item which has image
    func getBrowseImageItems() {
        let imageitems = imageViews.enumerated().map { (item) -> TTAImageBrowserViewModel in
            /// thumbnailImageView is the imageView with the image
            return TTAImageBrowserViewModel(image: item.element.image, thumbnailImageView: item.element)
        }
        groups.append(imageitems)
    }
    
    /// Tap gesture action to show the image browser
    func tap(tap: UITapGestureRecognizer) {
        guard let view = tap.view else { return };
        let tag = view.tag - ViewControllerConst.imageViewBaseTag
        
        /// Init the browser with the broweItems (one of 4 above), and the index you just tap
        let browseVc = TTAImageBrowserViewController(groups[currentValue], currentIndex:tag)
        
        /// The animation timeInterval when the browse show and dismiss
        browseVc.animationTimeInterval = 0.3
        if toastSwitch.isOn {
            /// Show the browser and do something you want after the browser has been shown
            browseVc.show {
                TTAImageBrowserRemindHUD.show("browseVc Show Success!")
            }
        } else {
            /// Show the broser
            browseVc.show()
        }

        print("Home Dic Path" + NSHomeDirectory())
    }
}

