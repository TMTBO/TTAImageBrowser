# TTAImageBrowser

[![Version](https://img.shields.io/cocoapods/v/TTAImageBrowser.svg?style=flat)](http://cocoapods.org/pods/TTAImageBrowser)
[![License](https://img.shields.io/cocoapods/l/TTAImageBrowser.svg?style=flat)](http://cocoapods.org/pods/TTAImageBrowser)
[![Platform](https://img.shields.io/cocoapods/p/TTAImageBrowser.svg?style=flat)](http://cocoapods.org/pods/TTAImageBrowser)

## Picture & Gif

![TTAImageBrowser](https://github.com/TMTBO/TTAImageBrowser/blob/master/TTAImageBrowser.gif)
![TTAImageBrowser_SaveImage](https://github.com/TMTBO/TTAImageBrowser/blob/master/TTAImageBrowser_SaveImage.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

>ios >= 8.0
>
>swift >= 3.1

## Installation

TTAImageBrowser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "TTAImageBrowser"
```

## Usage
```
// create 
let browseVc = TTAImageBrowserViewController(the_items, currentIndex:the_index_you_wanna_to_show_first)

// show
browseVc.show()
```
##API

### TTAImageBrowserViewController

	/// The timeInterval when the image browse enter and exit
    public var animationTimeInterval: TimeInterval
    
    /// Init method
    public convenience init(_ items: [TTAImageBrowser.TTAImageBrowserViewModel], currentIndex: Int)

    /// Show The ImageBrowser
    ///
    /// - Parameter completionHandler: The handler after the browser has been shown
    public func show(_ completionHandler: (() -> ())? = default)

### TTAImageBrowserViewModel

	/// Is the first one when open or not
	public var isFirstOpen: Bool

    /// Init the view model wiht image url and corresponding imageView
    public init(imageURL: String?, thumbnailImageView: UIImageView?)

    /// Init the view model wiht image localPath and corresponding imageView
    public init(imageLocalPath: String?, thumbnailImageView: UIImageView?)

    /// Init the view model wiht image and corresponding imageView
    public init(image: UIImage?, thumbnailImageView: UIImageView?)

    /// Init the view model wiht image data and corresponding imageView
    public init(data: Data?, thumbnailImageView: UIImageView?)

### TTAImageBrowserRemindHUD
	
	/// The HUD will always show in the center of the param `view`.
    /// If your will is widther or highter than the screen, maybe you should pass a `nil` or `UIApplication.shared.keyWindow` to the `view`
    public static func show(_ message: String?, dismissAfter time: TimeInterval = 1, in view: UIView? = UIApplication.shared.keyWindow)
    
    /// Dismiss the the HUD
    public static func dismiss(after: TimeInterval)

## Author

TMTBO, tmtbo@hotmail.com

## License

TTAImageBrowser is available under the MIT license. See the LICENSE file for more info.
