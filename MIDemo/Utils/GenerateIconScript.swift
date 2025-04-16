import UIKit

/*
 这个文件不会被编译到应用中，它是一个独立的Swift脚本，用于生成应用图标。
 使用方法：
 1. 在Xcode中创建一个新的Command Line Tool项目
 2. 复制此文件的内容到main.swift
 3. 运行项目，图标将被生成到指定位置
 */

/*
 使用方法：
 1. 在任何需要生成图标的地方调用 IconGenerator.generateAndSaveAppIcon()
 2. 图标将被保存到指定位置
 */

class IconGenerator {
    // MARK: - 图标生成函数
    
    static func generateAppIcon(size: CGSize) -> UIImage? {
        // 创建画布
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 背景色 - 品牌红色
        let backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        
        // 绘制圆角矩形背景
        let cornerRadius = size.width * 0.225 // iOS图标标准圆角
        let rect = CGRect(origin: .zero, size: size)
        
        context.setFillColor(backgroundColor.cgColor)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        context.addPath(path.cgPath)
        context.fillPath()
        
        // 绘制聊天气泡
        context.setFillColor(UIColor.white.cgColor)
        
        // 左气泡
        let leftBubbleRect = CGRect(
            x: size.width * 0.25,
            y: size.height * 0.35,
            width: size.width * 0.3,
            height: size.height * 0.23
        )
        let leftBubblePath = UIBezierPath(roundedRect: leftBubbleRect, cornerRadius: size.width * 0.04)
        context.addPath(leftBubblePath.cgPath)
        context.fillPath()
        
        // 右气泡
        let rightBubbleRect = CGRect(
            x: size.width * 0.45,
            y: size.height * 0.47,
            width: size.width * 0.3,
            height: size.height * 0.23
        )
        let rightBubblePath = UIBezierPath(roundedRect: rightBubbleRect, cornerRadius: size.width * 0.04)
        context.addPath(rightBubblePath.cgPath)
        context.fillPath()
        
        // 添加文字 "CM"
        let fontSize = size.width * 0.2
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        let text = "CM"
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2 + size.height * 0.12,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        // 获取生成的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - 保存图标到指定路径
    
    static func saveIcon(_ image: UIImage, name: String, toPath path: String) -> Bool {
        guard let data = image.pngData() else {
            print("❌ 无法将图像转换为PNG数据：\(name)")
            return false
        }
        
        let url = URL(fileURLWithPath: path).appendingPathComponent("\(name).png")
        
        do {
            try data.write(to: url)
            print("✅ 图标已保存：\(url.path)")
            return true
        } catch {
            print("❌ 保存图标失败：\(error)")
            return false
        }
    }
    
    // MARK: - 主执行方法
    
    static func generateAndSaveAppIcon() {
        let iconSizes: [(name: String, size: CGSize)] = [
            ("AppIcon", CGSize(width: 1024, height: 1024))
        ]
        
        let projectPath = "/Users/guangguang/Desktop/imdemo/MIDemo"
        let appIconPath = "\(projectPath)/MIDemo/Assets.xcassets/AppIcon.appiconset"
        
        // 确保目录存在
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: appIconPath) {
            do {
                try fileManager.createDirectory(atPath: appIconPath, withIntermediateDirectories: true)
                print("📁 创建目录：\(appIconPath)")
            } catch {
                print("❌ 创建目录失败：\(error)")
            }
        }
        
        // 生成并保存所有图标
        for (name, size) in iconSizes {
            print("🔄 正在生成：\(name) (\(Int(size.width))x\(Int(size.height)))")
            if let icon = generateAppIcon(size: size) {
                if saveIcon(icon, name: name, toPath: appIconPath) {
                    print("✓ 成功生成图标：\(name)")
                }
            } else {
                print("❌ 生成图标失败：\(name)")
            }
        }
        
        print("\n✅ 图标生成完成！\n")
    }
} 