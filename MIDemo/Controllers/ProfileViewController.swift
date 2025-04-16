//
//  ProfileViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "我的"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 0.1)
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.text = "wleng"
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "ID: 6"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "这是我的个性签名，展示我的特点和个性。"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var followersView = ProfileStatsView(title: "粉丝", count: 128)
    private lazy var followingView = ProfileStatsView(title: "关注", count: 256)
    private lazy var postsView = ProfileStatsView(title: "动态", count: 64)
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("编辑资料", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0).cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("分享", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var postsViewController: ProfilePostsViewController!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupPostsViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(settingsButton)
        
        view.addSubview(avatarImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(userIdLabel)
        view.addSubview(bioLabel)
        
        view.addSubview(statsContainerView)
        statsContainerView.addSubview(followersView)
        statsContainerView.addSubview(followingView)
        statsContainerView.addSubview(postsView)
        
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(editProfileButton)
        buttonStackView.addArrangedSubview(shareButton)
        
        view.addSubview(containerView)
        
        // Setup constraints
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(userIdLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        // Setup stats views with equal widths
        followersView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(statsContainerView.snp.width).multipliedBy(0.33)
        }
        
        followingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(statsContainerView.snp.width).multipliedBy(0.33)
        }
        
        postsView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(statsContainerView.snp.width).multipliedBy(0.33)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(statsContainerView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTapped))
        followersView.addGestureRecognizer(followersTap)
        followersView.isUserInteractionEnabled = true
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(followingTapped))
        followingView.addGestureRecognizer(followingTap)
        followingView.isUserInteractionEnabled = true
        
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTapped))
        postsView.addGestureRecognizer(postsTap)
        postsView.isUserInteractionEnabled = true
    }
    
    private func setupPostsViewController() {
        postsViewController = ProfilePostsViewController()
        addChild(postsViewController)
        containerView.addSubview(postsViewController.view)
        postsViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        postsViewController.didMove(toParent: self)
    }
    
    // MARK: - Actions
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func editProfileTapped() {
        // 实现编辑资料功能
    }
    
    @objc private func shareTapped() {
        // 实现分享功能
    }
    
    @objc private func followersTapped() {
        // 实现查看粉丝列表功能
    }
    
    @objc private func followingTapped() {
        // 实现查看关注列表功能
    }
    
    @objc private func postsTapped() {
        // 实现查看动态功能
    }
}

// MARK: - SettingsViewController
// ... existing code ...