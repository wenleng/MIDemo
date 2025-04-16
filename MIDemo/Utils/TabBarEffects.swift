//
//  TabBarEffects.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit

class TabBarEffects {

    // MARK: - 单例设计模式
    static let shared = TabBarEffects()
    private init() {}

    // MARK: - 显示烟花效果

    /// 在指定位置显示烟花效果
    /// - Parameters:
    ///   - tabBar: 标签栏
    ///   - index: 选项卡索引
    func showFireworks(in tabBar: UITabBar, at index: Int) {
        // 获取选项卡的位置
        guard let tabBarItems = tabBar.items,
              index < tabBarItems.count else {
            return
        }

        // 计算选项卡的位置
        let itemCount = CGFloat(tabBarItems.count)
        let tabBarWidth = tabBar.bounds.width
        let itemWidth = tabBarWidth / itemCount
        let xPosition = itemWidth * CGFloat(index) + itemWidth / 2

        // 创建烟花效果
        createFireworksEffect(at: CGPoint(x: xPosition, y: tabBar.bounds.height / 2), in: tabBar)

        // 触发震动反馈
        generateHapticFeedback()
    }

    // MARK: - 私有方法

    /// 创建烟花效果
    /// - Parameters:
    ///   - point: 烟花中心点
    ///   - view: 父视图
    private func createFireworksEffect(at point: CGPoint, in view: UIView) {
        // 主要颜色
        let mainColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)

        // 颜色变化
        let colors: [UIColor] = [
            mainColor,
            UIColor(red: 255/255, green: 120/255, blue: 120/255, alpha: 1.0),
            UIColor(red: 255/255, green: 150/255, blue: 150/255, alpha: 1.0),
            UIColor(red: 255/255, green: 180/255, blue: 180/255, alpha: 1.0),
            UIColor(red: 255/255, green: 200/255, blue: 200/255, alpha: 1.0)
        ]

        // 创建主要粒子
        createMainParticles(at: point, colors: colors, in: view)

        // 创建次要粒子
        createSecondaryParticles(at: point, colors: colors, in: view)

        // 创建小型闪光粒子
        createSparkles(at: point, color: mainColor, in: view)
    }

    // 中心圆点已移除

    /// 创建主要粒子
    private func createMainParticles(at point: CGPoint, colors: [UIColor], in view: UIView) {
        let particleCount = 12

        for i in 0..<particleCount {
            // 随机选择颜色和大小
            let color = colors[Int.random(in: 0..<colors.count)]
            let size = CGFloat.random(in: 5...8)

            // 创建粒子
            let particle = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            particle.backgroundColor = color
            particle.layer.cornerRadius = size / 2
            particle.center = point
            particle.alpha = 0
            view.addSubview(particle)

            // 计算粒子运动路径
            let angle = CGFloat(i) * (CGFloat.pi * 2) / CGFloat(particleCount)
            let distance = CGFloat.random(in: 35...50)

            let destinationX = point.x + cos(angle) * distance
            let destinationY = point.y + sin(angle) * distance

            // 添加随机性
            let randomOffsetX = CGFloat.random(in: -5...5)
            let randomOffsetY = CGFloat.random(in: -5...5)

            // 动画时间
            let duration = Double.random(in: 0.4...0.7)
            let delay = Double.random(in: 0...0.1)

            // 执行动画
            UIView.animate(withDuration: 0.1, delay: delay, options: .curveEaseOut, animations: {
                particle.alpha = 1
            }) { _ in
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    particle.center = CGPoint(x: destinationX + randomOffsetX, y: destinationY + randomOffsetY)
                    particle.alpha = 0
                    particle.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                }) { _ in
                    particle.removeFromSuperview()
                }
            }
        }
    }

    /// 创建次要粒子
    private func createSecondaryParticles(at point: CGPoint, colors: [UIColor], in view: UIView) {
        let particleCount = 20

        for _ in 0..<particleCount {
            // 随机选择颜色和大小
            let color = colors[Int.random(in: 0..<colors.count)]
            let size = CGFloat.random(in: 2...4)

            // 创建粒子
            let particle = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            particle.backgroundColor = color
            particle.layer.cornerRadius = size / 2
            particle.center = point
            particle.alpha = 0
            view.addSubview(particle)

            // 计算粒子运动路径
            let angle = CGFloat.random(in: 0...(CGFloat.pi * 2))
            let distance = CGFloat.random(in: 20...40)

            let destinationX = point.x + cos(angle) * distance
            let destinationY = point.y + sin(angle) * distance

            // 动画时间
            let duration = Double.random(in: 0.3...0.6)
            let delay = Double.random(in: 0.05...0.15)

            // 执行动画
            UIView.animate(withDuration: 0.1, delay: delay, options: .curveEaseOut, animations: {
                particle.alpha = 1
            }) { _ in
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    particle.center = CGPoint(x: destinationX, y: destinationY)
                    particle.alpha = 0
                }) { _ in
                    particle.removeFromSuperview()
                }
            }
        }
    }

    /// 创建小型闪光粒子
    private func createSparkles(at point: CGPoint, color: UIColor, in view: UIView) {
        let sparkleCount = 15

        for _ in 0..<sparkleCount {
            // 创建闪光粒子
            let size = CGFloat.random(in: 1...3)
            let sparkle = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            sparkle.backgroundColor = UIColor.white
            sparkle.layer.cornerRadius = size / 2

            // 随机位置
            let distance = CGFloat.random(in: 10...30)
            let angle = CGFloat.random(in: 0...(CGFloat.pi * 2))
            let startX = point.x + cos(angle) * CGFloat.random(in: 5...15)
            let startY = point.y + sin(angle) * CGFloat.random(in: 5...15)
            let endX = point.x + cos(angle) * distance
            let endY = point.y + sin(angle) * distance

            sparkle.center = CGPoint(x: startX, y: startY)
            sparkle.alpha = 0
            view.addSubview(sparkle)

            // 动画时间
            let duration = Double.random(in: 0.2...0.5)
            let delay = Double.random(in: 0...0.2)

            // 执行动画
            UIView.animate(withDuration: 0.05, delay: delay, options: .curveLinear, animations: {
                sparkle.alpha = 1
            }) { _ in
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    sparkle.center = CGPoint(x: endX, y: endY)
                    sparkle.alpha = 0
                }) { _ in
                    sparkle.removeFromSuperview()
                }
            }
        }
    }

    /// 生成震动反馈
    private func generateHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
