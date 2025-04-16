//
//  ChatViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {

    // MARK: - UI Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var inputToolbar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 2
        return view
    }()

    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入消息..."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        textField.layer.cornerRadius = 18
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftViewMode = .always
        textField.returnKeyType = .send
        textField.delegate = self
        textField.layer.borderWidth = 0
        textField.autocorrectionType = .no  // 禁用自动更正
        textField.spellCheckingType = .no   // 禁用拼写检查
        return textField
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 90/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var micButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    private var chatMessages: [ChatMessage] = []
    private var keyboardHeight: CGFloat = 0
    private var bottomConstraint: Constraint?

    let chatUser: User

    // MARK: - Lifecycle

    init(user: User) {
        self.chatUser = user
        super.init(nibName: nil, bundle: nil)
        // Hide tab bar when this view controller is pushed
        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTableView()
        loadMockMessages()
        setupKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 确保导航栏显示
        navigationController?.setNavigationBarHidden(false, animated: animated)

        // 禁用 IQKeyboardManager，因为我们有自己的键盘处理逻辑
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)

        // 恢复导航栏阴影，确保返回时样式正确
        navigationController?.navigationBar.restoreShadow()

        // 重新启用 IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)

        // 添加子视图
        view.addSubview(tableView)
        view.addSubview(inputToolbar)

        inputToolbar.addSubview(photoButton)
        inputToolbar.addSubview(emojiButton)
        inputToolbar.addSubview(micButton)
        inputToolbar.addSubview(inputTextField)
        inputToolbar.addSubview(sendButton)

        // 设置约束
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(inputToolbar.snp.top)
        }

        inputToolbar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            bottomConstraint = make.bottom.equalToSuperview().constraint
            make.height.equalTo(60)
        }

        photoButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        emojiButton.snp.makeConstraints { make in
            make.left.equalTo(photoButton.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        micButton.snp.makeConstraints { make in
            make.left.equalTo(emojiButton.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        inputTextField.snp.makeConstraints { make in
            make.left.equalTo(micButton.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(sendButton.snp.left).offset(-15)
            make.height.equalTo(36)
        }

        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(36)
        }
    }

    private func setupNavigationBar() {
        // 使用我们的扩展方法设置导航栏样式
        navigationController?.navigationBar.setupAppearance()

        // 移除导航栏阴影，聊天页面不需要阴影
        navigationController?.navigationBar.removeShadow()

        // 设置导航栏标题（聊天对象的名称）
        title = chatUser.nickname ?? chatUser.username

        // 自定义返回按钮
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        navigationItem.leftBarButtonItem = backButton

        // 更多选项按钮
        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(moreButtonTapped)
        )
        moreButton.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = moreButton
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: "SentMessageCell")
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: "ReceivedMessageCell")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func loadMockMessages() {
        // Create some initial messages
        let currentUser = User.currentUser

        let message1 = ChatMessage(
            id: 1,
            sender: chatUser,
            content: "你好！",
            timestamp: Date().addingTimeInterval(-3600),
            isRead: true
        )

        let message2 = ChatMessage(
            id: 2,
            sender: currentUser,
            content: "你好啊！最近怎么样？",
            timestamp: Date().addingTimeInterval(-3540),
            isRead: true
        )

        let message3 = ChatMessage(
            id: 3,
            sender: chatUser,
            content: "不错，我最近去了一个湖边旅游，风景很美！",
            timestamp: Date().addingTimeInterval(-3500),
            isRead: true
        )

        let message4 = ChatMessage(
            id: 4,
            sender: chatUser,
            content: "这是我拍的照片",
            timestamp: Date().addingTimeInterval(-3480),
            isRead: true,
            imageUrl: "photo3"
        )

        let message5 = ChatMessage(
            id: 5,
            sender: currentUser,
            content: "好漂亮！这是哪里？我也想去",
            timestamp: Date().addingTimeInterval(-3420),
            isRead: true
        )

        let message6 = ChatMessage(
            id: 6,
            sender: chatUser,
            content: "这是在城市外的一个小山上。日落时分景色特别美。周末我们一起去吧！",
            timestamp: Date().addingTimeInterval(-3400),
            isRead: true
        )

        let message7 = ChatMessage(
            id: 7,
            sender: currentUser,
            content: "好啊！周末我有空",
            timestamp: Date().addingTimeInterval(-3380),
            isRead: true
        )

        chatMessages = [message1, message2, message3, message4, message5, message6, message7]
        tableView.reloadData()

        // Scroll to bottom
        if chatMessages.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: chatMessages.count - 1, section: 0), at: .bottom, animated: false)
        }
    }

    // MARK: - Actions

    @objc private func sendButtonTapped() {
        guard let text = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return
        }

        let newMessage = ChatMessage(
            id: chatMessages.count + 1,
            sender: User.currentUser,
            content: text,
            timestamp: Date(),
            isRead: false
        )

        chatMessages.append(newMessage)

        // Insert row in tableView
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        // Scroll to bottom
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

        // Clear text field
        inputTextField.text = ""

        // Simulate reply after a delay
        if chatMessages.count % 3 == 0 {
            simulateReply()
        }
    }

    @objc private func photoButtonTapped() {
        // Show image picker
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            // Handle camera action
        })

        alertController.addAction(UIAlertAction(title: "从相册选择", style: .default) { _ in
            // Handle photo library action
            self.sendImageMessage()
        })

        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(alertController, animated: true)
    }

    @objc private func emojiButtonTapped() {
        // Show emoji picker (stub)
        let alertController = UIAlertController(title: "表情", message: "表情功能将在未来版本中开放", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default))
        present(alertController, animated: true)
    }

    @objc private func micButtonTapped() {
        // Show voice recorder (stub)
        let alertController = UIAlertController(title: "语音", message: "语音功能将在未来版本中开放", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default))
        present(alertController, animated: true)
    }

    @objc private func moreButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "清空聊天记录", style: .destructive) { _ in
            self.chatMessages.removeAll()
            self.tableView.reloadData()
        })

        alertController.addAction(UIAlertAction(title: "查看用户资料", style: .default) { _ in
            // Show user profile
        })

        alertController.addAction(UIAlertAction(title: "加入黑名单", style: .destructive))
        alertController.addAction(UIAlertAction(title: "举报", style: .default))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(alertController, animated: true)
    }

    @objc private func tableViewTapped() {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.keyboardHeight = keyboardHeight

            // 获取动画时间和曲线
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
            let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let curve = UIView.AnimationOptions(rawValue: curveValue)

            // 直接将输入工具栏移动到键盘上方，不考虑安全区域
            UIView.animate(withDuration: duration, delay: 0, options: curve) {
                self.bottomConstraint?.update(offset: -keyboardHeight)
                self.view.layoutIfNeeded()
            }

            // Scroll to bottom if there are messages
            if !self.chatMessages.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: self.chatMessages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // 获取动画时间和曲线
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let curve = UIView.AnimationOptions(rawValue: curveValue)

        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.bottomConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }

    @objc private func backButtonTapped() {
        // 返回上一级页面
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods

    private func simulateReply() {
        // Simulate typing indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let replies = [
                "好的，没问题👌",
                "我明白了，谢谢分享！",
                "哈哈，太有趣了😄",
                "我觉得这个主意不错",
                "好的，我们保持联系"
            ]

            let randomReply = replies[Int.random(in: 0..<replies.count)]

            let newMessage = ChatMessage(
                id: self.chatMessages.count + 1,
                sender: self.chatUser,
                content: randomReply,
                timestamp: Date(),
                isRead: true
            )

            self.chatMessages.append(newMessage)

            // Insert row in tableView
            let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)

            // Scroll to bottom
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    private func sendImageMessage() {
        // Get a random test image
        let imageNames = ["photo1", "photo2", "photo3", "photo4"]
        let randomImage = imageNames[Int.random(in: 0..<imageNames.count)]

        let newMessage = ChatMessage(
            id: chatMessages.count + 1,
            sender: User.currentUser,
            content: "",
            timestamp: Date(),
            isRead: false,
            imageUrl: randomImage
        )

        chatMessages.append(newMessage)

        // Insert row in tableView
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        // Scroll to bottom
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

        // Simulate reply after a delay
        simulateReply()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatMessages[indexPath.row]

        let reuseIdentifier = message.isFromCurrentUser ? "SentMessageCell" : "ReceivedMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatBubbleCell

        cell.configure(with: message)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 确保当输入框获得焦点时，消息列表滚动到底部
        if !chatMessages.isEmpty {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}