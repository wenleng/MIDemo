import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate - scene willConnectTo")

        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 创建窗口
        window = UIWindow(windowScene: windowScene)

        // 设置全局导航栏样式
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.setupAppearance()

        // 设置动态图标（仅在iOS 10.3+设备上）
        setupAlternateIcon()

        // 判断用户是否已登录
        if AuthManager.shared.isUserLoggedIn() {
            print("SceneDelegate - 用户已登录，设置主界面")
            // 用户已登录，设置主界面
            let mainTabBarController = MainTabBarController()
            window?.rootViewController = mainTabBarController
        } else {
            print("SceneDelegate - 用户未登录，设置登录界面")
            // 用户未登录，设置登录界面
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window?.rootViewController = navigationController
        }

        window?.makeKeyAndVisible()
        print("SceneDelegate - 窗口设置完成并显示")
    }

    // MARK: - 设置动态图标

    private func setupAlternateIcon() {
        // 如果设备支持动态更改图标，并且当前没有设置图标
        if UIApplication.shared.supportsAlternateIcons && !UserDefaults.standard.bool(forKey: "hasSetAppIcon") {
            // 保存标志，避免重复设置
            UserDefaults.standard.set(true, forKey: "hasSetAppIcon")
            UserDefaults.standard.synchronize()

            #if DEBUG
            print("📱 尝试设置应用图标...")

            // 生成并设置应用图标
            DispatchQueue.global(qos: .background).async {
                // 生成图标到Documents目录
                let icon = AppIconHelper.shared.generateIcon()

                // 在主线程显示提示
                DispatchQueue.main.async {
                    // 显示一个提示，解释如何手动设置图标
                    self.showIconSetupInstructions()
                }
            }
            #endif
        }
    }

    // 显示设置图标的说明
    private func showIconSetupInstructions() {
        // 创建一个警告控制器，提供指导
        let alertController = UIAlertController(
            title: "设置应用图标",
            message: "您需要手动将生成的图标设置为应用图标。在Xcode中:\n1. 打开Assets.xcassets\n2. 将生成的图标拖放到AppIcon.appiconset目录\n3. 清理并重新构建项目",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "了解", style: .default))

        // 在根视图控制器上显示警告
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alertController, animated: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}