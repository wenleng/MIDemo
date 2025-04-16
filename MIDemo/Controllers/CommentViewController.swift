//
//  CommentViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

protocol CommentViewControllerDelegate: AnyObject {
    func commentViewController(_ controller: CommentViewController, didAddComment comment: Comment, forPostId postId: Int)
}

class CommentViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "发表评论"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "说点什么..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: CommentViewControllerDelegate?
    private let postId: Int
    private var keyboardHeight: CGFloat = 0
    
    // MARK: - Initialization
    
    init(postId: Int) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        // 添加子视图
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(dividerView)
        containerView.addSubview(commentTextView)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(sendButton)
        
        // 设置约束
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(120)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(commentTextView).offset(10)
            make.left.equalTo(commentTextView).offset(15)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(commentTextView.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        // 添加手势和事件
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    private func setupTextView() {
        commentTextView.delegate = self
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
    
    // MARK: - Actions
    
    @objc private func backgroundTapped() {
        dismiss(animated: true)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func sendTapped() {
        guard let commentText = commentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !commentText.isEmpty else {
            return
        }
        
        // 创建新评论
        let newComment = Comment(
            id: Int.random(in: 100...10000), // 模拟ID生成
            user: User.currentUser,
            content: commentText
        )
        
        // 通知代理
        delegate?.commentViewController(self, didAddComment: newComment, forPostId: postId)
        
        // 关闭视图
        dismiss(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3) {
                self.containerView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-keyboardHeight)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate
extension CommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        placeholderLabel.isHidden = !text.isEmpty
        
        // 启用/禁用发送按钮
        let isEnabled = !text.isEmpty
        sendButton.isEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1.0 : 0.5
    }
}
