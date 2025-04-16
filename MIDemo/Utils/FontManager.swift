//
//  FontManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

enum FontManager {
    // MARK: - 标准字体
    static let header = UIFont.systemFont(ofSize: 24, weight: .bold)
    static let title = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let subtitle = UIFont.systemFont(ofSize: 18, weight: .medium)
    static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let button = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let caption = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let small = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    // MARK: - 自定义字体
    
    /// 创建自定义大小的常规字体
    static func regular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    /// 创建自定义大小的中等字体
    static func medium(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    /// 创建自定义大小的半粗体字体
    static func semibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    /// 创建自定义大小的粗体字体
    static func bold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    // MARK: - 字体比例
    
    /// 返回根据设备尺寸调整的字体大小
    static func scaledSize(_ baseSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        
        // 根据屏幕宽度进行简单的缩放调整
        if screenWidth <= 320 { // iPhone SE (1st gen)
            return baseSize * 0.85
        } else if screenWidth <= 375 { // iPhone SE (2nd gen), iPhone 8, X, etc.
            return baseSize * 0.9
        } else if screenWidth <= 414 { // iPhone 8 Plus, 11, etc.
            return baseSize
        } else { // iPads and larger devices
            return baseSize * 1.1
        }
    }
    
    /// 创建可缩放的字体 (根据设备自动调整大小)
    static func scaledFont(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let scaledSize = self.scaledSize(size)
        return UIFont.systemFont(ofSize: scaledSize, weight: weight)
    }
    
    // MARK: - 动态字体支持
    
    /// 创建支持动态类型的字体
    static func dynamicFont(for style: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        return UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
    }
    
    /// 为标签设置支持动态类型的字体
    static func applyDynamicType(to label: UILabel, style: UIFont.TextStyle, weight: UIFont.Weight = .regular) {
        label.font = dynamicFont(for: style, weight: weight)
        label.adjustsFontForContentSizeCategory = true
    }
} 