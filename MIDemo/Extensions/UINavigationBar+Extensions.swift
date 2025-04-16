//
//  UINavigationBar+Extensions.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

extension UINavigationBar {
    
    // 设置导航栏样式 - 标准版
    func setupAppearance() {
        // 设置基本样式
        self.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        self.barTintColor = .white
        self.isTranslucent = false
        
        // 设置标题样式
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        // 处理导航栏背景
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = UIColor.lightGray.withAlphaComponent(0.3)
            appearance.shadowImage = nil
            
            // 设置标题样式
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
            ]
            
            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
            self.compactAppearance = appearance
            
            if #available(iOS 15.0, *) {
                self.compactScrollEdgeAppearance = appearance
            }
        } else {
            // iOS 13以下版本
            self.shadowImage = nil
            self.setBackgroundImage(nil, for: .default)
        }
    }
    
    // 移除导航栏阴影
    func removeShadow() {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance.copy()
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
            self.compactAppearance = appearance
            
            if #available(iOS 15.0, *) {
                self.compactScrollEdgeAppearance = appearance
            }
        } else {
            // iOS 13以下版本
            self.shadowImage = UIImage()
            self.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    // 恢复导航栏阴影
    func restoreShadow() {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance.copy()
            appearance.shadowColor = UIColor.lightGray.withAlphaComponent(0.3)
            appearance.shadowImage = nil
            
            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
            self.compactAppearance = appearance
            
            if #available(iOS 15.0, *) {
                self.compactScrollEdgeAppearance = appearance
            }
        } else {
            // iOS 13以下版本
            self.shadowImage = nil
            self.setBackgroundImage(nil, for: .default)
        }
    }
}
