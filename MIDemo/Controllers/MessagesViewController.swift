//
//  MessagesViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class MessagesViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ChatMeet"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetManager.getImage(named: "app_logo") ?? UIImage(systemName: "bubble.left.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        return imageView
    }()
    
    private lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "搜索"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        textField.layer.cornerRadius = 18
        
        // 创建左侧搜索图标容器
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 36))
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.frame = CGRect(x: 15, y: 8, width: 20, height: 20)
        searchIcon.contentMode = .scaleAspectFit
        leftViewContainer.addSubview(searchIcon)
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        
        // 创建右侧加号按钮容器
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 36))
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .gray
        plusButton.frame = CGRect(x: 5, y: 8, width: 20, height: 20)
        rightViewContainer.addSubview(plusButton)
        textField.rightView = rightViewContainer
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    // MARK: - Properties
    
    private var messages: [Message] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        headerView.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        // Setup constraints
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
        // Add pull-to-refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func loadMockData() {
        // Create mock users
        let user1 = User(id: 1, username: "xiaoming", email: "xiaoming@example.com", 
                        password: "", nickname: "小明", gender: .male, age: 28)
        
        let user2 = User(id: 2, username: "xiaoyu", email: "xiaoyu@example.com", 
                        password: "", nickname: "小鱼", gender: .female, age: 23)
        
        let user3 = User(id: 3, username: "daming", email: "daming@example.com", 
                        password: "", nickname: "大明", gender: .male, age: 30)
        
        let user4 = User(id: 4, username: "yangguang", email: "yangguang@example.com", 
                        password: "", nickname: "阳光", gender: .male, age: 28)
        
        let user5 = User(id: 5, username: "xiaoai", email: "xiaoai@example.com", 
                        password: "", nickname: "小爱", gender: .female, age: 22)
        
        // Create mock messages
        let message1 = Message(
            id: 1,
            sender: user1,
            receiver: User.currentUser,
            lastMessage: "你好啊！最近在忙什么呢？我刚从山里回来...",
            unreadCount: 2,
            timestamp: Date().addingTimeInterval(-300) // 5 minutes ago
        )
        
        let message2 = Message(
            id: 2,
            sender: user2,
            receiver: User.currentUser,
            lastMessage: "吃饭了吗？一起去饭店吧！",
            unreadCount: 0,
            timestamp: Date().addingTimeInterval(-7200) // 2 hours ago
        )
        
        let message3 = Message(
            id: 3,
            sender: user3,
            receiver: User.currentUser,
            lastMessage: "最近有什么好电影推荐吗?",
            unreadCount: 0,
            timestamp: Date().addingTimeInterval(-86400) // 1 day ago
        )
        
        let message4 = Message(
            id: 4,
            sender: user4,
            receiver: User.currentUser,
            lastMessage: "上周末那个活动真的很赞！下次再约！",
            unreadCount: 0,
            timestamp: Date().addingTimeInterval(-172800) // 2 days ago
        )
        
        let message5 = Message(
            id: 5,
            sender: user5,
            receiver: User.currentUser,
            lastMessage: "谢谢你的帮助，我已经解决那个问题了👍",
            unreadCount: 0,
            timestamp: Date().addingTimeInterval(-259200) // 3 days ago
        )
        
        messages = [message1, message2, message3, message4, message5]
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func refreshData() {
        // Simulate network loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = messages[indexPath.row]
        let chatVC = ChatViewController(user: message.sender)
        navigationController?.pushViewController(chatVC, animated: true)
    }
} 