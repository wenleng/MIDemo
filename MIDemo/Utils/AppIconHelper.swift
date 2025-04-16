import UIKit

class AppIconHelper {
    
    static let shared = AppIconHelper()
    
    private let iconSize = CGSize(width: 1024, height: 1024)
    private let primaryColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
    
    /// 生成并保存应用图标
    func generateAndSaveIcon() {
        // 获取Documents目录路径
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { 
            print("❌ 无法访问Documents目录")
            return 
        }
        
        // 生成图标
        guard let iconImage = generateIcon() else {
            print("❌ 无法生成图标")
            return
        }
        
        // 保存图标到Documents目录
        let iconURL = documentsPath.appendingPathComponent("ChatMeet_AppIcon.png")
        
        guard let pngData = iconImage.pngData() else {
            print("❌ 无法将图标转换为PNG数据")
            return
        }
        
        do {
            try pngData.write(to: iconURL)
            print("✅ 图标已生成并保存到: \(iconURL.path)")
            print("ℹ️ 请手动将此图标添加到项目的Assets.xcassets/AppIcon.appiconset目录中")
            
            // 显示如何添加图标的指南
            showIconAddingInstructions(iconURL: iconURL)
        } catch {
            print("❌ 保存图标失败: \(error.localizedDescription)")
        }
    }
    
    /// 显示如何添加图标的指导
    private func showIconAddingInstructions(iconURL: URL) {
        print("")
        print("== 如何添加图标到项目中 ==")
        print("1. 从Finder中打开: \(iconURL.path)")
        print("2. 将图标文件拖放到Xcode中的Assets.xcassets/AppIcon.appiconset目录")
        print("3. 确保Contents.json文件引用了AppIcon.png")
        print("4. 清理项目(Product > Clean Build Folder)并重新构建")
        print("====================")
        print("")
    }
    
    /// 生成应用图标
    func generateIcon(size: CGSize = CGSize(width: 1024, height: 1024)) -> UIImage? {
        return generateAppIcon()
    }
    
    /// 生成应用图标
    private func generateAppIcon() -> UIImage? {
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
} 