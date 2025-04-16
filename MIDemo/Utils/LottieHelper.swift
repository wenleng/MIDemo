//
//  LottieHelper.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import Lottie

enum LottieHelper {
    
    // 标准动画名称
    static let successAnimation = "success_animation"
    static let loadingAnimation = "loading_animation"
    static let loginAnimation = "login_animation"
    
    // 动画缓存目录
    static let animationCacheDirectory: String = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectory = paths[0].appendingPathComponent("com.lottie.animation.cache")
        try? FileManager.default.createDirectory(at: cachesDirectory, withIntermediateDirectories: true)
        return cachesDirectory.path
    }()
    
    /// 设置默认动画
    static func setupDefaultAnimations() {
        // 当没有动画资源文件时，创建一个简单的动画
        
        // 成功动画
        if !animationExists(named: successAnimation) {
            createSuccessAnimation()
        }
        
        // 加载动画
        if !animationExists(named: loadingAnimation) {
            createLoadingAnimation()
        }
        
        // 登录动画
        if !animationExists(named: loginAnimation) {
            createLoginAnimation()
        }
    }
    
    /// 检查动画是否存在
    private static func animationExists(named: String) -> Bool {
        let animationPath = Bundle.main.path(forResource: named, ofType: "json",
                                            inDirectory: animationCacheDirectory)
        return animationPath != nil
    }
    
    /// 创建成功动画
    private static func createSuccessAnimation() {
        let successData: [String: Any] = [
            "v": "5.5.7",
            "fr": 30,
            "ip": 0,
            "op": 30,
            "w": 200,
            "h": 200,
            "layers": [
                [
                    "ty": 4,
                    "nm": "Check",
                    "sr": 1,
                    "shapes": [
                        [
                            "ty": "sh",
                            "ks": [
                                "k": [
                                    [
                                        "i": [[0, 0], [0, 0], [0, 0]],
                                        "o": [[0, 0], [0, 0], [0, 0]],
                                        "v": [[50, 100], [90, 140], [150, 60]],
                                        "c": false
                                    ]
                                ]
                            ]
                        ],
                        [
                            "ty": "st",
                            "c": [ 0, 0.8, 0, 1 ],
                            "w": 10,
                            "lc": 2,
                            "lj": 2
                        ],
                        [
                            "ty": "tr",
                            "p": [ 0, 0 ],
                            "a": [ 0, 0 ],
                            "s": [ 100, 100 ],
                            "r": 0,
                            "o": 100
                        ]
                    ],
                    "op": 30
                ]
            ]
        ]
        
        saveAnimation(data: successData, named: successAnimation)
    }
    
    /// 创建加载动画
    private static func createLoadingAnimation() {
        let loadingData: [String: Any] = [
            "v": "5.5.7",
            "fr": 30,
            "ip": 0,
            "op": 60,
            "w": 200,
            "h": 200,
            "layers": [
                [
                    "ty": 4,
                    "nm": "Spinner",
                    "sr": 1,
                    "shapes": [
                        [
                            "ty": "el",
                            "p": [ 100, 100 ],
                            "s": [ 120, 120 ]
                        ],
                        [
                            "ty": "st",
                            "c": [ 0, 0.5, 1, 1 ],
                            "w": 10,
                            "lc": 2,
                            "lj": 2
                        ],
                        [
                            "ty": "tr",
                            "p": [ 0, 0 ],
                            "a": [ 0, 0 ],
                            "s": [ 100, 100 ],
                            "r": [ 0, 360 ],
                            "o": 100
                        ]
                    ],
                    "op": 60
                ]
            ]
        ]
        
        saveAnimation(data: loadingData, named: loadingAnimation)
    }
    
    /// 创建登录动画
    private static func createLoginAnimation() {
        let loginData: [String: Any] = [
            "v": "5.5.7",
            "fr": 30,
            "ip": 0,
            "op": 60,
            "w": 200,
            "h": 200,
            "layers": [
                [
                    "ty": 4,
                    "nm": "Icon",
                    "sr": 1,
                    "shapes": [
                        [
                            "ty": "el",
                            "p": [ 100, 100 ],
                            "s": [ 80, 80 ]
                        ],
                        [
                            "ty": "fl",
                            "c": [ 0, 0.5, 1, 1 ]
                        ],
                        [
                            "ty": "tr",
                            "p": [ 0, 0 ],
                            "a": [ 0, 0 ],
                            "s": [ 100, 100 ],
                            "r": 0,
                            "o": [ 50, 100 ]
                        ]
                    ],
                    "op": 60
                ]
            ]
        ]
        
        saveAnimation(data: loginData, named: loginAnimation)
    }
    
    /// 保存动画到文件
    private static func saveAnimation(data: [String: Any], named: String) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
            let directory = animationCacheDirectory
            
            // 确保目录存在
            let directoryURL = URL(fileURLWithPath: directory)
            try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            
            // 保存动画JSON文件
            let fileURL = directoryURL.appendingPathComponent("\(named).json")
            try? jsonData.write(to: fileURL)
        }
    }
    
    /// 获取动画视图
    static func getAnimationView(named: String, loopMode: LottieLoopMode = .loop) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: named)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
} 