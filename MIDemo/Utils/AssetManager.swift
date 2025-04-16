//
//  AssetManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SDWebImage

class AssetManager {
    
    // 缓存远程图片URL映射
    private static var imageURLCache: [String: URL] = [:]
    
    // 获取图片 - 可以处理本地图片和URL图片
    static func getImage(named name: String) -> UIImage? {
        // 如果是app_logo，则使用LogoGenerator生成
        if name == "app_logo" {
            return LogoGenerator.generateLogo(size: CGSize(width: 100, height: 100))
        }
        
        // 检查是否为系统图标
        if #available(iOS 13.0, *), name.hasPrefix("system_") {
            let systemName = name.replacingOccurrences(of: "system_", with: "")
            return UIImage(systemName: systemName)
        }
        
        // 检查是否已缓存为URL
        if let imageURL = imageURLCache[name] {
            return SDImageCache.shared.imageFromCache(forKey: imageURL.absoluteString)
        }
        
        // 从Assets获取图片
        if let image = UIImage(named: name) {
            return image
        }
        
        // 如果没有找到图片，生成一个默认图标
        return drawDefaultIcon(name: name)
    }
    
    // 从URL加载图片并缓存
    static func loadImage(from urlString: String, named name: String? = nil, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        
        // 如果提供了名称，缓存URL映射
        if let name = name {
            imageURLCache[name] = url
        }
        
        // 使用SDWebImage加载和缓存
        SDWebImageManager.shared.loadImage(
            with: url,
            options: [],
            progress: nil
        ) { (image, _, error, _, _, _) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
            completion?(image)
        }
    }
    
    // 预加载多个图片资源
    static func preloadImages(urls: [String]) {
        let urls = urls.compactMap { URL(string: $0) }
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    
    // 清除特定图片缓存
    static func clearImageCache(for name: String) {
        if let url = imageURLCache[name] {
            SDImageCache.shared.removeImage(forKey: url.absoluteString)
            imageURLCache.removeValue(forKey: name)
        }
    }
    
    // 清除所有图片缓存
    static func clearAllImageCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        imageURLCache.removeAll()
    }
    
    // 绘制默认图标（当请求的图标不存在时使用）
    private static func drawDefaultIcon(name: String) -> UIImage? {
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 绘制背景
        let rect = CGRect(origin: .zero, size: size)
        context.setFillColor(UIColor.lightGray.cgColor)
        
        // 绘制一个内边距为4的矩形
        let insetRect = rect.insetBy(dx: 4, dy: 4)
        context.fill(insetRect)
        
        // 绘制文本 (首字母)
        let firstChar = name.prefix(1).uppercased()
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        let textSize = firstChar.size(withAttributes: textAttributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        firstChar.draw(in: textRect, withAttributes: textAttributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
} 