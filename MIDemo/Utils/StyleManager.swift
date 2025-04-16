//
//  StyleManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

enum StyleManager {
    // MARK: - 按钮样式
    
    /// 配置主按钮样式
    static func applyPrimaryButtonStyle(to button: UIButton) {
        button.backgroundColor = ColorManager.primary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontManager.button
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
    /// 配置次要按钮样式
    static func applySecondaryButtonStyle(to button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(ColorManager.primary, for: .normal)
        button.titleLabel?.font = FontManager.button
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.primary.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
    /// 配置文本按钮样式
    static func applyTextButtonStyle(to button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(ColorManager.primary, for: .normal)
        button.titleLabel?.font = FontManager.button
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    // MARK: - 文本输入框样式
    
    /// 配置标准文本输入框样式
    static func applyStandardTextFieldStyle(to textField: UITextField) {
        textField.font = FontManager.body
        textField.textColor = ColorManager.textPrimary
        textField.backgroundColor = ColorManager.backgroundPrimary
        textField.layer.borderWidth = 1
        textField.layer.borderColor = ColorManager.border.cgColor
        textField.layer.cornerRadius = 8
        
        // 添加左侧内边距
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        // 添加右侧内边距
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
    }
    
    /// 配置搜索栏样式
    static func applySearchBarStyle(to searchBar: UISearchBar) {
        // iOS 13+ 可以使用 searchTextField
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = ColorManager.backgroundSecondary
            searchBar.searchTextField.textColor = ColorManager.textPrimary
            searchBar.searchTextField.font = FontManager.body
        } else {
            // iOS 12 兼容方案
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.backgroundColor = ColorManager.backgroundSecondary
                textField.textColor = ColorManager.textPrimary
                textField.font = FontManager.body
            }
        }
        
        // 通用搜索栏设置
        searchBar.barTintColor = ColorManager.backgroundPrimary
        searchBar.tintColor = ColorManager.primary
        
        // 配置搜索栏圆角
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 8
            textField.clipsToBounds = true
        }
    }
    
    // MARK: - 导航栏样式
    
    /// 配置标准导航栏样式
    static func applyStandardNavigationBarStyle(to navigationBar: UINavigationBar) {
        // 设置标题字体和颜色
        navigationBar.titleTextAttributes = [
            .foregroundColor: ColorManager.textPrimary,
            .font: FontManager.title
        ]
        
        // 导航栏样式
        navigationBar.tintColor = ColorManager.primary
        navigationBar.barTintColor = ColorManager.backgroundPrimary
        
        // iOS 13+ 支持新的导航栏外观
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ColorManager.backgroundPrimary
            appearance.titleTextAttributes = [
                .foregroundColor: ColorManager.textPrimary,
                .font: FontManager.title
            ]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
    }
    
    // MARK: - 标签栏样式
    
    /// 配置标准标签栏样式
    static func applyStandardTabBarStyle(to tabBar: UITabBar) {
        // 标签栏基本样式
        tabBar.tintColor = ColorManager.primary
        tabBar.barTintColor = ColorManager.backgroundPrimary
        
        // iOS 13+ 支持新的标签栏外观
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ColorManager.backgroundPrimary
            
            let itemAppearance = UITabBarItemAppearance()
            
            // 设置未选中状态的文本属性
            itemAppearance.normal.titleTextAttributes = [
                .foregroundColor: ColorManager.textSecondary,
                .font: FontManager.caption
            ]
            
            // 设置选中状态的文本属性
            itemAppearance.selected.titleTextAttributes = [
                .foregroundColor: ColorManager.primary,
                .font: FontManager.caption
            ]
            
            appearance.stackedLayoutAppearance = itemAppearance
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            // iOS 12 兼容方案
            UITabBarItem.appearance().setTitleTextAttributes([
                .foregroundColor: ColorManager.textSecondary,
                .font: FontManager.caption
            ], for: .normal)
            
            UITabBarItem.appearance().setTitleTextAttributes([
                .foregroundColor: ColorManager.primary,
                .font: FontManager.caption
            ], for: .selected)
        }
    }
    
    // MARK: - 表格视图样式
    
    /// 配置标准表格视图样式
    static func applyStandardTableViewStyle(to tableView: UITableView) {
        tableView.backgroundColor = ColorManager.backgroundSecondary
        tableView.separatorColor = ColorManager.divider
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    /// 配置表格视图单元格样式
    static func applyStandardCellStyle(to cell: UITableViewCell) {
        cell.backgroundColor = ColorManager.backgroundPrimary
        cell.textLabel?.font = FontManager.body
        cell.textLabel?.textColor = ColorManager.textPrimary
        cell.detailTextLabel?.font = FontManager.caption
        cell.detailTextLabel?.textColor = ColorManager.textSecondary
        
        // 设置选中背景色
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = ColorManager.primary.withAlphaComponent(0.1)
        cell.selectedBackgroundView = selectedBackgroundView
    }
    
    // MARK: - 卡片视图样式
    
    /// 配置标准卡片视图样式
    static func applyCardStyle(to view: UIView) {
        view.backgroundColor = ColorManager.cardBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
    }
    
    // MARK: - 标签样式
    
    /// 配置标准标签样式
    static func applyLabelStyle(to label: UILabel, style: LabelStyle) {
        switch style {
        case .header:
            label.font = FontManager.header
            label.textColor = ColorManager.textPrimary
        case .title:
            label.font = FontManager.title
            label.textColor = ColorManager.textPrimary
        case .subtitle:
            label.font = FontManager.subtitle
            label.textColor = ColorManager.textSecondary
        case .body:
            label.font = FontManager.body
            label.textColor = ColorManager.textPrimary
        case .caption:
            label.font = FontManager.caption
            label.textColor = ColorManager.textSecondary
        }
    }
    
    // MARK: - 辅助类型
    
    /// 标签样式类型
    enum LabelStyle {
        case header
        case title
        case subtitle
        case body
        case caption
    }
} 