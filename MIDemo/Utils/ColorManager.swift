//
//  ColorManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

enum ColorManager {
    // MARK: - 主题颜色
    
    /// 主题色
    static var primary: UIColor {
        return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    /// 次要主题色
    static var secondary: UIColor {
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    
    /// 强调色
    static var accent: UIColor {
        return UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    // MARK: - 文本颜色
    
    /// 主文本颜色
    static var textPrimary: UIColor {
        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    /// 次要文本颜色
    static var textSecondary: UIColor {
        return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }
    
    /// 提示文本颜色
    static var textHint: UIColor {
        return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    }
    
    /// 禁用文本颜色
    static var textDisabled: UIColor {
        return UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    }
    
    // MARK: - 背景色
    
    /// 主背景色
    static var backgroundPrimary: UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    /// 次要背景色
    static var backgroundSecondary: UIColor {
        return UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    
    /// 卡片背景色
    static var cardBackground: UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    // MARK: - 边框和分割线
    
    /// 边框颜色
    static var border: UIColor {
        return UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
    
    /// 分割线颜色
    static var divider: UIColor {
        return UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
    
    // MARK: - 状态颜色
    
    /// 成功状态颜色
    static var success: UIColor {
        return UIColor(red: 40.0/255.0, green: 167.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    }
    
    /// 警告状态颜色
    static var warning: UIColor {
        return UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    /// 错误状态颜色
    static var error: UIColor {
        return UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    /// 信息状态颜色
    static var info: UIColor {
        return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    // MARK: - 辅助方法
    
    /// 创建自定义颜色
    static func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    /// 从十六进制值创建颜色
    static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// 扩展UIColor以支持十六进制颜色代码
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        var red, green, blue: CGFloat
        
        if hexString.count == 6 {
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(white: 1.0, alpha: 1.0)
        }
    }
} 