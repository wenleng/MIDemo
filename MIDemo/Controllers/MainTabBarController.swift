//
//  MainTabBarController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBar()

        // 设置代理，使用自身作为代理
        self.delegate = self
    }

    private func setupViewControllers() {
        // 主界面（附近的人）
        let nearbyVC = NearbyViewController()
        let nearbyNav = UINavigationController(rootViewController: nearbyVC)
        nearbyNav.tabBarItem = UITabBarItem(title: "附近", image: UIImage(systemName: "location"), selectedImage: UIImage(systemName: "location.fill"))

        // 消息
        let messagesVC = MessagesViewController()
        let messagesNav = UINavigationController(rootViewController: messagesVC)
        messagesNav.tabBarItem = UITabBarItem(title: "消息", image: UIImage(systemName: "bubble.left"), selectedImage: UIImage(systemName: "bubble.left.fill"))

        // 动态广场
        let momentsVC = MomentsViewController()
        let momentsNav = UINavigationController(rootViewController: momentsVC)
        momentsNav.tabBarItem = UITabBarItem(title: "动态", image: UIImage(systemName: "square.grid.2x2"), selectedImage: UIImage(systemName: "square.grid.2x2.fill"))

        // 个人资料
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        viewControllers = [nearbyNav, messagesNav, momentsNav, profileNav]
    }

    private func customizeTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 当用户选择一个标签项时触发
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            // 显示烟花效果和震动
            TabBarEffects.shared.showFireworks(in: tabBarController.tabBar, at: index)
        }
    }
}

// MARK: - 附近的人
class NearbyViewController: UIViewController {

    private let segmentedControl: UISegmentedControl = {
        let items = ["全部", "女生", "男生", "1km内"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = UIColor.systemGray6
        control.selectedSegmentTintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        control.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return control
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(UserCardCell.self, forCellWithReuseIdentifier: UserCardCell.identifier)
        return cv
    }()

    private var nearbyUsers: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateSampleUsers()
    }

    private func setupUI() {
        title = "附近的人"
        view.backgroundColor = .white

        // 设置导航栏
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setupAppearance()
        navigationController?.navigationBar.restoreShadow() // 确保主页面显示阴影

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )

        // 添加子视图
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)

        // 设置约束
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        // 设置代理
        collectionView.delegate = self
        collectionView.dataSource = self
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func generateSampleUsers() {
        nearbyUsers = [
            User(id: 1, username: "小明", email: "xm@example.com", password: "password123", nickname: "小明", gender: .male, age: 25),
            User(id: 2, username: "阳光", email: "yg@example.com", password: "password123", nickname: "阳光", gender: .female, age: 28),
            User(id: 3, username: "小雪", email: "xx@example.com", password: "password123", nickname: "小雪", gender: .female, age: 23),
            User(id: 4, username: "大卫", email: "dw@example.com", password: "password123", nickname: "大卫", gender: .male, age: 30),
            User(id: 5, username: "金鑫", email: "jx@example.com", password: "password123", nickname: "金鑫", gender: .male, age: 26),
            User(id: 6, username: "小晴", email: "xq@example.com", password: "password123", nickname: "小晴", gender: .female, age: 22),
        ]

        collectionView.reloadData()
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // 根据选择的分段过滤用户
        collectionView.reloadData()
    }

    @objc private func menuButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "刷新", style: .default))
        alertController.addAction(UIAlertAction(title: "设置", style: .default))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - 用户卡片单元格
class UserCardCell: UICollectionViewCell {
    static let identifier = "UserCardCell"

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .lightGray
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        return label
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    private let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("聊聊", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("关注", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1

        // 添加子视图
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(chatButton)
        contentView.addSubview(followButton)

        // 设置约束
        avatarImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
        }

        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(8)
        }

        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel)
        }

        chatButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo((contentView.frame.width - 24) / 2)
            make.height.equalTo(32)
        }

        followButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(chatButton)
            make.height.equalTo(32)
        }
    }

    func configure(with user: User) {
        nameLabel.text = user.nickname ?? user.username
        ageLabel.text = "\(user.age ?? 0) 岁"

        // 随机距离
        let distance = Int.random(in: 1...10)
        distanceLabel.text = "距离 \(distance)km"

        // 设置头像 - 使用新生成的头像图片
        switch user.username {
        case "小明":
            avatarImageView.image = UIImage(named: "avatar1") // 蓝色头像给小明
            avatarImageView.backgroundColor = nil
        case "阳光":
            avatarImageView.image = UIImage(named: "avatar2") // 粉色头像给阳光
            avatarImageView.backgroundColor = nil
        case "小雪":
            avatarImageView.image = UIImage(named: "avatar3") // 浅粉色头像给小雪
            avatarImageView.backgroundColor = nil
        case "大卫":
            avatarImageView.image = UIImage(named: "avatar4") // 蓝紫色头像给大卫
            avatarImageView.backgroundColor = nil
        default:
            // 使用性别默认头像
        if user.gender == .female {
                avatarImageView.image = UIImage(named: "avatar3") // 默认使用头像3
                avatarImageView.backgroundColor = nil
        } else {
                avatarImageView.image = UIImage(named: "avatar1") // 默认使用头像1
                avatarImageView.backgroundColor = nil
            }
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension NearbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var filteredUsers = nearbyUsers

        // 根据分段选择筛选用户
        switch segmentedControl.selectedSegmentIndex {
        case 1: // 女生
            filteredUsers = nearbyUsers.filter { $0.gender == .female }
        case 2: // 男生
            filteredUsers = nearbyUsers.filter { $0.gender == .male }
        case 3: // 1km内
            filteredUsers = nearbyUsers.filter { _ in Int.random(in: 0...1) == 1 } // 随机模拟1km内
        default:
            break
        }

        return filteredUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCardCell.identifier, for: indexPath) as! UserCardCell

        var filteredUsers = nearbyUsers

        // 根据分段选择筛选用户
        switch segmentedControl.selectedSegmentIndex {
        case 1: // 女生
            filteredUsers = nearbyUsers.filter { $0.gender == .female }
        case 2: // 男生
            filteredUsers = nearbyUsers.filter { $0.gender == .male }
        case 3: // 1km内
            filteredUsers = nearbyUsers.filter { _ in Int.random(in: 0...1) == 1 } // 随机模拟1km内
        default:
            break
        }

        if indexPath.item < filteredUsers.count {
            cell.configure(with: filteredUsers[indexPath.item])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 2
        return CGSize(width: width, height: width * 1.6)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var filteredUsers = nearbyUsers

        // 根据分段选择筛选用户
        switch segmentedControl.selectedSegmentIndex {
        case 1: // 女生
            filteredUsers = nearbyUsers.filter { $0.gender == .female }
        case 2: // 男生
            filteredUsers = nearbyUsers.filter { $0.gender == .male }
        case 3: // 1km内
            filteredUsers = nearbyUsers.filter { _ in Int.random(in: 0...1) == 1 } // 随机模拟1km内
        default:
            break
        }

        if indexPath.item < filteredUsers.count {
            let user = filteredUsers[indexPath.item]
            let alertController = UIAlertController(title: user.nickname ?? user.username, message: "查看详细资料", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "确定", style: .default))
            present(alertController, animated: true)
        }
    }
}

// MARK: - 消息 Tab
// Using the main MessagesViewController from MessagesViewController.swift
// ... existing code ...

// MARK: - 我的 Tab
// Using the main ProfileViewController from ProfileViewController.swift
// ... existing code ...