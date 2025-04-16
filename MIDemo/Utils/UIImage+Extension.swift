//
//  UIImage+Extension.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SDWebImage

extension UIImage {
    static func compatibleSystemImage(named name: String) -> UIImage? {
        return AssetManager.getImage(named: name)
    }
}

// 扩展 UIImageView 以便于使用 SDWebImage
extension UIImageView {
    /// 从URL加载图片，使用SDWebImage
    func sd_setImageWithURL(_ url: URL?, placeholder: UIImage? = nil, completion: ((UIImage?, Error?) -> Void)? = nil) {
        self.sd_setImage(with: url, placeholderImage: placeholder) { (image, error, _, _) in
            completion?(image, error)
        }
    }
    
    /// 加载图片 - 支持本地图片名称和URL
    func loadImage(named name: String, placeholder: UIImage? = nil) {
        // 检查是否是URL
        if let url = URL(string: name) {
            sd_setImageWithURL(url, placeholder: placeholder)
            return
        }
        
        // 否则从AssetManager获取
        self.image = AssetManager.getImage(named: name) ?? placeholder
    }
} 