import UIKit

class AppIconGenerator {
    
    static func generateAndSaveAppIcon() {
        // 获取项目目录
        let fileManager = FileManager.default
        
        // 获取应用资源目录
        let appIconsetURL = Bundle.main.bundleURL
            .deletingLastPathComponent() // 移除应用bundle
            .deletingLastPathComponent() // 移除Products目录
            .appendingPathComponent("MIDemo")
            .appendingPathComponent("Assets.xcassets")
            .appendingPathComponent("AppIcon.appiconset")
        
        // 生成图标
        guard let iconImage = generateAppIcon() else {
            print("❌ 无法生成应用图标")
            return
        }
        
        // 保存图标到AppIcon.appiconset目录
        let iconPath = appIconsetURL.appendingPathComponent("AppIcon.png")
        
        guard let pngData = iconImage.pngData() else {
            print("❌ 无法将图标转换为PNG数据")
            return
        }
        
        do {
            try pngData.write(to: iconPath)
            print("✅ 应用图标已生成并保存到: \(iconPath.path)")
        } catch {
            print("❌ 保存应用图标失败: \(error)")
        }
    }
    
    static func generateAppIcon(size: CGSize = CGSize(width: 1024, height: 1024)) -> UIImage? {
        let iconSize = size
        let primaryColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        
        // 创建画布
        UIGraphicsBeginImageContextWithOptions(iconSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 绘制圆角矩形背景
        let cornerRadius = iconSize.width * 0.225
        let rect = CGRect(origin: .zero, size: iconSize)
        
        context.setFillColor(primaryColor.cgColor)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        context.addPath(path.cgPath)
        context.fillPath()
        
        // 绘制聊天气泡
        context.setFillColor(UIColor.white.cgColor)
        
        // 左气泡
        let leftBubbleRect = CGRect(
            x: iconSize.width * 0.25,
            y: iconSize.height * 0.35,
            width: iconSize.width * 0.3,
            height: iconSize.height * 0.23
        )
        let leftBubblePath = UIBezierPath(roundedRect: leftBubbleRect, cornerRadius: iconSize.width * 0.04)
        context.addPath(leftBubblePath.cgPath)
        context.fillPath()
        
        // 右气泡
        let rightBubbleRect = CGRect(
            x: iconSize.width * 0.45,
            y: iconSize.height * 0.47,
            width: iconSize.width * 0.3,
            height: iconSize.height * 0.23
        )
        let rightBubblePath = UIBezierPath(roundedRect: rightBubbleRect, cornerRadius: iconSize.width * 0.04)
        context.addPath(rightBubblePath.cgPath)
        context.fillPath()
        
        // 添加文字 "CM"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: iconSize.width * 0.2, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        let text = "CM"
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (iconSize.width - textSize.width) / 2,
            y: (iconSize.height - textSize.height) / 2 + iconSize.height * 0.12,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        // 获取图像并返回
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func saveAppIcon() {
        guard let appIcon = generateAppIcon() else {
            print("Failed to generate app icon")
            return
        }
        
        guard let pngData = appIcon.pngData() else {
            print("Failed to convert app icon to PNG data")
            return
        }
        
        // 保存到Documents目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("ChatMeet_AppIcon.png")
        
        do {
            try pngData.write(to: fileURL)
            print("App icon saved to: \(fileURL.path)")
        } catch {
            print("Error saving app icon: \(error)")
        }
    }
    
    /// 在运行时保存图标到应用包内
    static func saveAppIconToAssets() {
        #if DEBUG
        guard let appIcon = generateAppIcon() else {
            print("❌ 无法生成应用图标")
            return
        }
        
        guard let pngData = appIcon.pngData() else {
            print("❌ 无法将应用图标转换为PNG数据")
            return
        }
        
        // 使用Documents目录作为临时存储
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("AppIcon.png")
            
            do {
                try pngData.write(to: fileURL)
                print("✅ 应用图标已临时保存至: \(fileURL.path)")
                print("ℹ️ 请手动将该图片添加到Assets.xcassets/AppIcon.appiconset中")
            } catch {
                print("❌ 保存应用图标失败: \(error)")
            }
        }
        #endif
    }
} 