//
//  LayoutConstants.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

enum LayoutConstants {
    // 标准边距和间距
    static let standardMargin: CGFloat = 16.0
    static let largeMargin: CGFloat = 24.0
    static let smallMargin: CGFloat = 8.0
    
    // 内容间距
    static let contentSpacing: CGFloat = 12.0
    static let groupSpacing: CGFloat = 20.0
    
    // 圆角大小
    static let standardCornerRadius: CGFloat = 8.0
    static let buttonCornerRadius: CGFloat = 22.0
    static let cardCornerRadius: CGFloat = 12.0
    
    // 控件高度
    static let buttonHeight: CGFloat = 44.0
    static let inputFieldHeight: CGFloat = 44.0
    static let navigationBarHeight: CGFloat = 44.0
    static let tabBarHeight: CGFloat = 49.0
    
    // 图标尺寸
    static let smallIconSize: CGFloat = 24.0
    static let mediumIconSize: CGFloat = 36.0
    static let largeIconSize: CGFloat = 48.0
    
    // 头像尺寸
    static let smallAvatarSize: CGFloat = 32.0
    static let mediumAvatarSize: CGFloat = 48.0
    static let largeAvatarSize: CGFloat = 64.0
    
    // 字体大小
    static let headerFontSize: CGFloat = 22.0
    static let titleFontSize: CGFloat = 17.0
    static let bodyFontSize: CGFloat = 15.0
    static let captionFontSize: CGFloat = 13.0
    
    // 线条粗细
    static let thinBorderWidth: CGFloat = 0.5
    static let standardBorderWidth: CGFloat = 1.0
    
    // 屏幕宽高
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // 安全区域
    static var safeAreaInsets: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else {
            return UIEdgeInsets.zero
        }
        return window.safeAreaInsets
    }
} 