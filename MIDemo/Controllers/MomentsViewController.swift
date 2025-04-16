//
//  MomentsViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class MomentsViewController: UIViewController {

    // MARK: - UI Components

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ChatMeet广场"
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

    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let createPostView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 0.1)
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        return imageView
    }()

    private let createPostTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "分享你的动态..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private let postActionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    private let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.setTitle(" 图片", for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.setTitle(" 位置", for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private let mentionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "at"), for: .normal)
        button.setTitle(" 好友", for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发布", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()

    // MARK: - Properties

    private var posts: [Post] = []

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MomentsViewController - viewDidLoad")
        setupUI()
        setupTableView()
        loadMockData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MomentsViewController - viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MomentsViewController - viewDidAppear")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        // 添加子视图
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(cameraButton)

        view.addSubview(createPostView)
        createPostView.addSubview(avatarImageView)
        createPostView.addSubview(createPostTextField)
        createPostView.addSubview(postActionsStackView)

        postActionsStackView.addArrangedSubview(imageButton)
        postActionsStackView.addArrangedSubview(locationButton)
        postActionsStackView.addArrangedSubview(mentionButton)
        createPostView.addSubview(postButton)

        view.addSubview(tableView)

        // 设置约束
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

        cameraButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        createPostView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(110)
        }

        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(36)
        }

        createPostTextField.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(36)
        }

        postActionsStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(30)
        }

        postButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(createPostView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }

        // 设置事件
        createPostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createPostTapped)))
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        mentionButton.addTarget(self, action: #selector(mentionButtonTapped), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")

        // 添加下拉刷新
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func loadMockData() {
        // 创建一些模拟用户
        let user1 = User(id: 1, username: "xiaojing", email: "xiaojing@example.com",
                        password: "", nickname: "小静", gender: .female, age: 25)

        let user2 = User(id: 2, username: "xiaoyu", email: "xiaoyu@example.com",
                        password: "", nickname: "小鱼", gender: .female, age: 23)

        let user3 = User(id: 3, username: "daming", email: "daming@example.com",
                        password: "", nickname: "大明", gender: .male, age: 30)

        let user4 = User(id: 4, username: "yangguang", email: "yangguang@example.com",
                        password: "", nickname: "阳光", gender: .male, age: 28)

        // 创建一些模拟评论
        let comment1 = Comment(id: 1, user: user3, content: "照片拍得真美，是在哪里拍的？")
        let comment2 = Comment(id: 2, user: user2, content: "在城市郊外的一个小山坡上，风景很棒！")
        let comment3 = Comment(id: 3, user: user4, content: "我也在读这本书，确实很棒！")

        // 使用测试图片替换系统图标
        let natureImageNames = ["photo1", "photo2", "photo3"]
        let fitnessImageName = "photo4"
        let bookImageName = "photo1"

        // 创建一些模拟动态
        let post1 = Post(
            id: 1,
            user: user1,
            content: "今天天气真好，拍了几张照片分享给大家～",
            images: natureImageNames,
            likes: 15,
            comments: [comment1, comment2],
            createdAt: Date().addingTimeInterval(-600) // 10分钟前
        )

        let post2 = Post(
            id: 2,
            user: user4,
            content: "今天在健身房完成了新的个人记录！坚持就是胜利💪",
            images: [fitnessImageName],
            likes: 25,
            comments: [],
            createdAt: Date().addingTimeInterval(-7200) // 2小时前
        )

        let post3 = Post(
            id: 3,
            user: user2,
            content: "推荐一本最近在读的书《原子习惯》，真的很有启发，教你如何通过微小的改变实现巨大的成果。",
            images: [bookImageName],
            likes: 38,
            comments: [comment3],
            createdAt: Date().addingTimeInterval(-10800) // 3小时前
        )

        posts = [post1, post2, post3]
        print("已加载模拟数据，共\(posts.count)条动态")
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func createPostTapped() {
        let alertController = UIAlertController(title: "创建动态", message: "该功能将在未来版本中开放", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default))
        present(alertController, animated: true)
    }

    @objc private func postButtonTapped() {
        createPostTapped()
    }

    @objc private func imageButtonTapped() {
        createPostTapped()
    }

    @objc private func locationButtonTapped() {
        createPostTapped()
    }

    @objc private func mentionButtonTapped() {
        createPostTapped()
    }

    @objc private func cameraButtonTapped() {
        createPostTapped()
    }

    @objc private func refreshData() {
        // 模拟网络加载
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    @objc private func likeTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if indexPath.row < posts.count {
            // 在真实应用中，这里会调用API来点赞/取消点赞
            var newPosts = posts // 使用var声明，使其可变
            let post = newPosts[indexPath.row]
            // 模拟点赞/取消点赞
            let newPost = Post(
                id: post.id,
                user: post.user,
                content: post.content,
                images: post.images,
                location: post.location,
                mentions: post.mentions,
                likes: post.likes + 1,
                comments: post.comments,
                createdAt: post.createdAt
            )
            newPosts[indexPath.row] = newPost
            posts = newPosts
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    @objc private func commentTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if indexPath.row < posts.count {
            let post = posts[indexPath.row]
            let commentVC = CommentViewController(postId: post.id)
            commentVC.delegate = self
            present(commentVC, animated: true)
        }
    }

    @objc private func shareTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "分享", message: "分享功能将在未来版本中开放", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default))
        present(alertController, animated: true)
    }

    @objc private func moreOptionsTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "举报", style: .destructive))
        alertController.addAction(UIAlertAction(title: "复制链接", style: .default))
        alertController.addAction(UIAlertAction(title: "不感兴趣", style: .default))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MomentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.configure(with: post)

        // 设置按钮标签用于事件处理
        cell.likeButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row

        // 设置按钮点击事件
        cell.likeButton.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentTapped(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(shareTapped(_:)), for: .touchUpInside)
        cell.moreButton.addTarget(self, action: #selector(moreOptionsTapped(_:)), for: .touchUpInside)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

// MARK: - CommentViewControllerDelegate
extension MomentsViewController: CommentViewControllerDelegate {
    func commentViewController(_ controller: CommentViewController, didAddComment comment: Comment, forPostId postId: Int) {
        // 查找对应的帖子
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            // 创建新的帖子对象，添加评论
            var post = posts[index]
            var newComments = post.comments
            newComments.append(comment)

            // 创建更新后的帖子
            let updatedPost = Post(
                id: post.id,
                user: post.user,
                content: post.content,
                images: post.images,
                location: post.location,
                mentions: post.mentions,
                likes: post.likes,
                comments: newComments,
                createdAt: post.createdAt
            )

            // 更新数据源
            posts[index] = updatedPost

            // 更新UI
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}