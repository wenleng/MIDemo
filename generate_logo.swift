import UIKit

// 创建一个画布
let size = CGSize(width: 512, height: 512)
UIGraphicsBeginImageContextWithOptions(size, false, 0)
let context = UIGraphicsGetCurrentContext()!

// 设置背景为圆形
context.setFillColor(UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0).cgColor)
context.fillEllipse(in: CGRect(x: 50, y: 50, width: 412, height: 412))

// 绘制聊天气泡图标
context.setFillColor(UIColor.white.cgColor)
// 左气泡
let leftBubblePath = UIBezierPath(roundedRect: CGRect(x: 120, y: 180, width: 160, height: 120), cornerRadius: 20)
context.addPath(leftBubblePath.cgPath)
context.fillPath()

// 右气泡
let rightBubblePath = UIBezierPath(roundedRect: CGRect(x: 230, y: 240, width: 160, height: 120), cornerRadius: 20)
context.addPath(rightBubblePath.cgPath)
context.fillPath()

// 添加文字 "MI"
let attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.systemFont(ofSize: 100, weight: .bold),
    .foregroundColor: UIColor.white
]
let text = "MI"
let textSize = text.size(withAttributes: attributes)
let textRect = CGRect(
    x: (size.width - textSize.width) / 2,
    y: (size.height - textSize.height) / 2 + 60,
    width: textSize.width,
    height: textSize.height
)
text.draw(in: textRect, withAttributes: attributes)

// 获取图像并保存
let image = UIGraphicsGetImageFromCurrentImageContext()!
UIGraphicsEndImageContext()

// 将图像转换为PNG数据
if let pngData = image.pngData() {
    // 保存到Documents目录
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsDirectory.appendingPathComponent("app_logo.png")
    try? pngData.write(to: fileURL)
    print("Logo saved to: \(fileURL.path)")
} 