//
//  LoginViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit
import Lottie
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
        imageView.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 0.1)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎来到ChatMeet"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "登录您的ChatMeet账号"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "手机号/邮箱"
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let phoneFieldSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "密码"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.shadowColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 0.3).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("创建新账号", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("忘记密码?", for: .normal)
        button.setTitleColor(UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    private let thirdPartyLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "其他登录方式"
        label.textAlignment = .center
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let socialButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func createSocialButton(tintColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = tintColor
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    private lazy var wechatButton: UIButton = createSocialButton(tintColor: UIColor(red: 9/255, green: 187/255, blue: 7/255, alpha: 1.0))
    private lazy var qqButton: UIButton = createSocialButton(tintColor: UIColor(red: 54/255, green: 164/255, blue: 244/255, alpha: 1.0))
    private lazy var weiboButton: UIButton = createSocialButton(tintColor: UIColor(red: 230/255, green: 22/255, blue: 45/255, alpha: 1.0))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        // 使用AssetManager加载logo
        logoImageView.image = AssetManager.getImage(named: "app_logo")
        
        // 设置社交按钮图标
        if let wechatImage = AssetManager.getImage(named: "wechat_icon")?.withRenderingMode(.alwaysTemplate) {
            wechatButton.setImage(wechatImage, for: .normal)
        }
        
        if let qqImage = AssetManager.getImage(named: "qq_icon")?.withRenderingMode(.alwaysTemplate) {
            qqButton.setImage(qqImage, for: .normal)
        }
        
        if let weiboImage = AssetManager.getImage(named: "weibo_icon")?.withRenderingMode(.alwaysTemplate) {
            weiboButton.setImage(weiboImage, for: .normal)
        }
        
        // Generate sample users for demo
        DatabaseManager.shared.generateSampleUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置IQKeyboardManager对当前控制器的特定配置
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UITextField.self]
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(phoneTextField)
        inputContainerView.addSubview(phoneFieldSeparator)
        inputContainerView.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(registerButton)
        view.addSubview(thirdPartyLoginLabel)
        
        socialButtonsStack.addArrangedSubview(wechatButton)
        socialButtonsStack.addArrangedSubview(qqButton)
        socialButtonsStack.addArrangedSubview(weiboButton)
        view.addSubview(socialButtonsStack)
        
        // Setup layout constraints
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        inputContainerView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        phoneFieldSeparator.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneFieldSeparator.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(inputContainerView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(50)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.right.equalTo(loginButton)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.left.equalTo(loginButton)
        }
        
        thirdPartyLoginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(socialButtonsStack.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        socialButtonsStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        wechatButton.addTarget(self, action: #selector(socialLoginTapped), for: .touchUpInside)
        qqButton.addTarget(self, action: #selector(socialLoginTapped), for: .touchUpInside)
        weiboButton.addTarget(self, action: #selector(socialLoginTapped), for: .touchUpInside)
        
        // 使用IQKeyboardManager处理键盘，不需要手动添加手势
        
        // Setup delegate for text fields
        phoneTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        guard let username = phoneTextField.text, !username.isEmpty else {
            showToast(message: "请输入手机号或邮箱", type: .warning)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showToast(message: "请输入密码", type: .warning)
            return
        }
        
        // 使用系统自带的活动指示器替代Lottie动画
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tag = 1001
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // 移除活动指示器
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            // Authenticate user
            guard let self = self else { return }
            if let user = DatabaseManager.shared.authenticateUser(username: username, password: password) {
                self.loginSuccess(user: user)
            } else {
                self.showToast(message: "用户名或密码不正确", type: .error)
            }
        }
    }
    
    private func loginSuccess(user: User) {
        // 保存登录状态
        AuthManager.shared.loginUser(user)
        
        // 导航到主应用
        self.navigateToMainApp()
    }
    
    private func navigateToMainApp() {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.selectedIndex = 0 // 确保选中首页/附近标签
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: nil)
    }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController()
        if let navigationController = self.navigationController {
            navigationController.pushViewController(registerVC, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: registerVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    @objc private func forgotPasswordTapped() {
        showToast(message: "此功能暂未实现，请联系客服", type: .info)
    }
    
    @objc private func socialLoginTapped(_ sender: UIButton) {
        var platform = "微信"
        if sender == qqButton {
            platform = "QQ"
        } else if sender == weiboButton {
            platform = "微博"
        }
        showToast(message: "\(platform)登录功能暂未实现", type: .info)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped()
        }
        return true
    }
} 