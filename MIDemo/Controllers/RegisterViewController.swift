//
//  RegisterViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit
import Lottie
import IQKeyboardManagerSwift
import SDWebImage

class RegisterViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "注册新账号"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "register_animation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        return animationView
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "用户名"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "邮箱"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入手机号"
        textField.borderStyle = .none
        textField.keyboardType = .phonePad
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let phoneFieldSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入人设密码"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let passwordFieldSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "设置您的年龄 (18-70岁学生勿注册)"
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let ageFieldSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("注册", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "注册即同意《用户协议》和《隐私政策》"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        // 预加载动画图片
        preloadAnimationAssets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置IQKeyboardManager对当前控制器的特定配置
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UITextField.self]
        
        // 设置忽略特定视图
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(RegisterViewController.self)
        
        // 开始播放动画
        animationView.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 仅在这里保留开始动画的代码
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup navigation bar
        navigationItem.title = "注册新账号"
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = UIColor.black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(animationView)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(phoneTextField)
        view.addSubview(phoneFieldSeparator)
        view.addSubview(passwordTextField)
        view.addSubview(passwordFieldSeparator)
        view.addSubview(ageTextField)
        view.addSubview(ageFieldSeparator)
        view.addSubview(registerButton)
        view.addSubview(termsLabel)
        
        // Setup constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(100)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(15)
            make.left.right.height.equalTo(usernameTextField)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.left.right.height.equalTo(usernameTextField)
        }
        
        phoneFieldSeparator.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(5)
            make.left.right.equalTo(phoneTextField)
            make.height.equalTo(1)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneFieldSeparator.snp.bottom).offset(20)
            make.left.right.height.equalTo(phoneTextField)
        }
        
        passwordFieldSeparator.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(1)
        }
        
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordFieldSeparator.snp.bottom).offset(20)
            make.left.right.height.equalTo(phoneTextField)
        }
        
        ageFieldSeparator.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(5)
            make.left.right.equalTo(ageTextField)
            make.height.equalTo(1)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(ageFieldSeparator.snp.bottom).offset(40)
            make.left.right.equalTo(phoneTextField)
            make.height.equalTo(44)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        // 使用IQKeyboardManager处理键盘，不需要手动添加手势
        
        // Setup delegates for text fields
        usernameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        ageTextField.delegate = self
    }
    
    @objc private func backButtonTapped() {
        // 确保调用完成后 pop
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func registerButtonTapped() {
        // Validate input fields
        guard let username = usernameTextField.text, !username.isEmpty else {
            showToast(message: "请输入用户名", type: .warning)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty, isValidEmail(email) else {
            showToast(message: "请输入有效的邮箱地址", type: .warning)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
            showToast(message: "密码长度需至少6位", type: .warning)
            return
        }
        
        guard let age = ageTextField.text, !age.isEmpty, let ageInt = Int(age), ageInt >= 18 && ageInt <= 70 else {
            showToast(message: "请输入有效的年龄 (18-70岁)", type: .warning)
            return
        }
        
        // Perform registration
        let phoneNumber = phoneTextField.text?.isEmpty == false ? phoneTextField.text : nil
        
        // Show loading animation
        let loadingAnimation = LottieAnimationView(name: "loading_animation")
        loadingAnimation.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        loadingAnimation.center = view.center
        loadingAnimation.contentMode = .scaleAspectFit
        loadingAnimation.loopMode = .loop
        loadingAnimation.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingAnimation.layer.cornerRadius = 10
        loadingAnimation.clipsToBounds = true
        view.addSubview(loadingAnimation)
        loadingAnimation.play()
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            loadingAnimation.removeFromSuperview()
            
            // Create new user
            if let user = DatabaseManager.shared.createUser(username: username, email: email, password: password, phoneNumber: phoneNumber) {
                self?.registrationSuccess(user: user)
            } else {
                self?.showToast(message: "用户名或邮箱已存在", type: .error)
            }
        }
    }
    
    private func registrationSuccess(user: User) {
        // Play success animation
        let successAnimation = LottieAnimationView(name: "success_animation")
        successAnimation.frame = view.bounds
        successAnimation.contentMode = .scaleAspectFit
        successAnimation.loopMode = .playOnce
        view.addSubview(successAnimation)
        successAnimation.play { [weak self] _ in
            successAnimation.removeFromSuperview()
            
            // 显示成功Toast并在一段时间后返回
            self?.showToast(message: "注册成功，即将返回登录页面", type: .success)
            
            // 延迟一段时间后返回上一页
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // 预加载Lottie动画所需的图片资源
    private func preloadAnimationAssets() {
        // 预加载注册流程可能用到的图片资源
        if let avatarURL = URL(string: "https://example.com/default-avatar.jpg") {
            SDWebImagePrefetcher.shared.prefetchURLs([avatarURL])
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            ageTextField.becomeFirstResponder()
        case ageTextField:
            registerButtonTapped()
        default:
            break
        }
        return true
    }
} 