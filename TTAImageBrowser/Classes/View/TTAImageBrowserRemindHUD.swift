//
//  TTAImageBrowserRemindHUD.swift
//  Pods
//
//  Created by TobyoTenma on 13/04/2017.
//
//

import UIKit

class TTAImageBrowserRemindHUD: UIVisualEffectView {
    
    static let shared = TTAImageBrowserRemindHUD()
    
    fileprivate let tipLabel = UILabel()
    
    init() {
        let blureStyle: UIBlurEffectStyle
        if #available(iOS 10.0, *) {
            blureStyle = .prominent
        } else {
            blureStyle = .extraLight
        }
        let blur = UIBlurEffect(style: blureStyle)
        super.init(effect: blur)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

// MARK: - Public Method

extension TTAImageBrowserRemindHUD {
    
    /// The HUD will always show in the center of the param `view`.
    /// If your will is widder or highter than the screen, maybe you should pass a `nil` or `UIApplication.shared.keyWindow` to the `view`
    static func show(_ message: String?, dismissAfter time: TimeInterval = 1, in view: UIView? = UIApplication.shared.keyWindow) {
        let hud = TTAImageBrowserRemindHUD.shared
        hud.calculateSize(string: message)
        guard let view = view else { return }
        hud.center = view.center
        view.addSubview(hud)
        hud.tipLabel.text = message
        dismiss(after: time)
    }
    /// Dismiss the the HUD
    static func dismiss(after: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            let hud = TTAImageBrowserRemindHUD.shared
            hud.removeFromSuperview()
        }
    }
}

// MARK: - Private Method

extension TTAImageBrowserRemindHUD {
    func calculateSize(string: String?) {
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 100)
        let stringSize: CGSize
        if let string = string {
            let asize = (string as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: tipLabel.font], context: nil).size
            stringSize = CGSize(width: asize.width + 20, height: asize.height + 20)
        } else {
            stringSize = .zero
        }
        bounds.size = stringSize
    }
}

// MARK: - UI

fileprivate extension TTAImageBrowserRemindHUD {
    func setupUI() {
        func _addViews() {
            addSubview(tipLabel)
        }
        func _configViews() {
            backgroundColor = .clear
            layer.cornerRadius = 5
            clipsToBounds = true
            
            tipLabel.font = UIFont.systemFont(ofSize: 18)
            tipLabel.textColor = .darkGray
            tipLabel.textAlignment = .center
            tipLabel.numberOfLines = 0
        }
        func _layoutViews() {
            tipLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        _addViews()
        _configViews()
        _layoutViews()
    }
}
