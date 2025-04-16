//
//  ColorTheme.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

enum ColorTheme {
    // 主题主色调
    static let primary = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    // 辅助色调
    static let secondary = UIColor(red: 64.0/255.0, green: 156.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    // 背景色
    static let background = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    
    // 文本颜色
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.darkGray
    static let textTertiary = UIColor.gray
    static let textLight = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    
    // 边框颜色
    static let border = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    
    // 按钮颜色
    static let buttonBackground = primary
    static let buttonText = UIColor.white
    static let buttonCornerRadius: CGFloat = 22.0
    
    // 输入框颜色
    static let inputBackground = UIColor.white
    static let inputBorder = border
    static let inputText = textPrimary
    static let inputPlaceholder = textTertiary
    
    // 其他常用颜色
    static let success = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    static let warning = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let error = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    
    // 社交媒体颜色
    static let wechat = UIColor(red: 9.0/255.0, green: 187.0/255.0, blue: 7.0/255.0, alpha: 1.0)
    static let qq = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    static let weibo = UIColor(red: 230.0/255.0, green: 22.0/255.0, blue: 45.0/255.0, alpha: 1.0)
} 