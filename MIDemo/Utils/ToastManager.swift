//
//  ToastManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

class ToastManager {
    
    // MARK: - 单例设计模式
    static let shared = ToastManager()
    private init() {}
    
    // MARK: - 配置参数
    private struct Constants {
        static let defaultDuration: TimeInterval = 2.0
        static let defaultPadding: CGFloat = 16.0
        static let defaultCornerRadius: CGFloat = 8.0
        static let defaultFontSize: CGFloat = 14.0
        static let defaultOpacity: CGFloat = 0.8
    }
    
    // MARK: - 显示Toast
    
    /// 显示简单的文本Toast
    /// - Parameters:
    ///   - message: 要显示的消息
    ///   - duration: 显示时长
    /// - Returns: 返回创建的Toast视图
    @discardableResult
    func showToast(message: String, duration: TimeInterval = Constants.defaultDuration) -> UIView? {
        guard let window = getKeyWindow() else {
            return nil
        }
        
        return showToast(message: message, in: window, duration: duration)
    }
    
    /// 在指定视图中显示Toast
    /// - Parameters:
    ///   - message: 要显示的消息
    ///   - view: 要显示Toast的视图
    ///   - duration: 显示时长
    /// - Returns: 返回创建的Toast视图
    @discardableResult
    func showToast(message: String, in view: UIView, duration: TimeInterval = Constants.defaultDuration) -> UIView {
        // 创建并配置Toast视图
        let toastView = createToastView(message: message)
        view.addSubview(toastView)
        
        // 位置设置
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding * 2),
            toastView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constants.defaultPadding),
            toastView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constants.defaultPadding)
        ])
        
        // 动画显示与隐藏
        toastView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                toastView.alpha = 0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
        
        return toastView
    }
    
    /// 显示带有状态的Toast (成功/失败/警告)
    /// - Parameters:
    ///   - message: 要显示的消息
    ///   - type: Toast类型
    ///   - duration: 显示时长
    /// - Returns: 返回创建的Toast视图
    @discardableResult
    func showToast(message: String, type: ToastType, duration: TimeInterval = Constants.defaultDuration) -> UIView? {
        guard let window = getKeyWindow() else {
            return nil
        }
        
        // 创建并配置Toast视图
        let toastView = createToastView(message: message, type: type)
        window.addSubview(toastView)
        
        // 位置设置
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding * 2),
            toastView.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: Constants.defaultPadding),
            toastView.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -Constants.defaultPadding)
        ])
        
        // 动画显示与隐藏
        toastView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                toastView.alpha = 0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
        
        return toastView
    }
    
    // MARK: - 辅助方法
    
    /// 创建基础Toast视图
    private func createToastView(message: String, type: ToastType? = nil) -> UIView {
        // 创建容器视图
        let toastView = UIView()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(Constants.defaultOpacity)
        toastView.layer.cornerRadius = Constants.defaultCornerRadius
        toastView.clipsToBounds = true
        
        // 根据类型选择图标
        var iconImageView: UIImageView?
        if let toastType = type {
            iconImageView = UIImageView()
            
            switch toastType {
            case .success:
                iconImageView?.image = UIImage(named: "toast_success") ?? createSuccessImage()
                iconImageView?.tintColor = .green
            case .error:
                iconImageView?.image = UIImage(named: "toast_error") ?? createErrorImage()
                iconImageView?.tintColor = .red
            case .warning:
                iconImageView?.image = UIImage(named: "toast_warning") ?? createWarningImage()
                iconImageView?.tintColor = .yellow
            case .info:
                iconImageView?.image = UIImage(named: "toast_info") ?? createInfoImage()
                iconImageView?.tintColor = .blue
            }
            
            iconImageView?.contentMode = .scaleAspectFit
            if let iconImageView = iconImageView {
                toastView.addSubview(iconImageView)
                iconImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    iconImageView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 12),
                    iconImageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
                    iconImageView.widthAnchor.constraint(equalToConstant: 20),
                    iconImageView.heightAnchor.constraint(equalToConstant: 20)
                ])
            }
        }
        
        // 创建标签
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.defaultFontSize)
        label.numberOfLines = 0
        label.textAlignment = .center
        toastView.addSubview(label)
        
        // 设置标签约束
        label.translatesAutoresizingMaskIntoConstraints = false
        if let iconImageView = iconImageView {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -12),
                label.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 12),
                label.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -12)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 12),
                label.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -12)
            ])
        }
        
        return toastView
    }
    
    // MARK: - 创建图标图像
    
    private func createSuccessImage() -> UIImage {
        return createSymbolImage(systemName: "checkmark.circle", fallbackText: "✓")
    }
    
    private func createErrorImage() -> UIImage {
        return createSymbolImage(systemName: "xmark.circle", fallbackText: "✕")
    }
    
    private func createWarningImage() -> UIImage {
        return createSymbolImage(systemName: "exclamationmark.triangle", fallbackText: "⚠")
    }
    
    private func createInfoImage() -> UIImage {
        return createSymbolImage(systemName: "info.circle", fallbackText: "ℹ")
    }
    
    private func createSymbolImage(systemName: String, fallbackText: String) -> UIImage {
        if #available(iOS 13.0, *) {
            if let symbolImage = UIImage(systemName: systemName) {
                return symbolImage
            }
        }
        
        // 创建文本图像作为后备
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
        
        let textRect = CGRect(origin: .zero, size: size)
        fallbackText.draw(in: textRect, withAttributes: attributes)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    /// 获取当前活跃窗口
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            // iOS 13及以上使用UIWindowScene
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }.first ?? UIApplication.shared.windows.first
        } else {
            // iOS 12及以下使用传统方法
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}

// MARK: - Toast类型
enum ToastType {
    case success
    case error
    case warning
    case info
}

// MARK: - UIViewController扩展
extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        ToastManager.shared.showToast(message: message, in: self.view, duration: duration)
    }
    
    func showToast(message: String, type: ToastType, duration: TimeInterval = 2.0) {
        ToastManager.shared.showToast(message: message, type: type, duration: duration)
    }
} 