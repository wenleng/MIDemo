import UIKit

class LogoGenerator {
    
    static func generateLogo(size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        // 创建一个画布
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        // 设置背景为圆形
        context.setFillColor(UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0).cgColor)
        context.fillEllipse(in: CGRect(x: size.width * 0.1, y: size.height * 0.1, width: size.width * 0.8, height: size.height * 0.8))
        
        // 绘制聊天气泡图标
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
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size.width * 0.2, weight: .bold),
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
        
        // 获取图像并返回
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return image
    }
} 