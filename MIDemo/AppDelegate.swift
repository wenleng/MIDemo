//
//  AppDelegate.swift
//  MIDemo
//
//  Created for MIDemo.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("AppDelegate - 应用启动")

        // 设置IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true

        // 检查并创建应用图标
        generateAppIconIfNeeded()

        // 设置全局导航栏样式
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.setupAppearance()

        // Setup window and initial view controller for iOS 12 support
        window = UIWindow(frame: UIScreen.main.bounds)

        // 检查是否已经登录
        if AuthManager.shared.isUserLoggedIn() {
            // 用户已登录，直接显示主界面
            let mainTabBarController = MainTabBarController()
            window?.rootViewController = mainTabBarController
        } else {
            // 未登录，显示登录界面
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window?.rootViewController = navigationController
        }

        window?.makeKeyAndVisible()

        #if DEBUG
        // 生成应用图标（仅在DEBUG模式下）
        AppIconGenerator.generateAndSaveAppIcon()
        #endif

        return true
    }

    // MARK: - UISceneSession Lifecycle

    // These methods are only used in iOS 13+
    // Keep them commented out for iOS 12 compatibility

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        print("AppDelegate - 配置新场景")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - App Icon Generation

    private func generateAppIconIfNeeded() {
        #if DEBUG
        // 仅在调试模式下生成图标
        IconGenerator.generateAndSaveAppIcon()

        // 显示一个辅助信息
        print("⚠️ 提示：App图标需要手动添加到Xcode项目中才能正确显示。")
        print("请查看控制台输出的详细指南。")
        #endif
    }
}

