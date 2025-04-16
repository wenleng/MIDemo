//
//  MessageCell.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class MessageCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        // Default image
        imageView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 0.1)
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private let unreadBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        view.layer.cornerRadius = 9
        view.isHidden = true
        return view
    }()
    
    private let unreadCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    
    private var message: Message?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unreadBadge.isHidden = true
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        backgroundColor = .white
        selectionStyle = .gray
        
        // Add subviews
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(unreadBadge)
        unreadBadge.addSubview(unreadCountLabel)
        
        // Setup constraints
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-8)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(unreadBadge.snp.left).offset(-8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(60)
        }
        
        unreadBadge.snp.makeConstraints { make in
            make.centerY.equalTo(messageLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(18)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add separator line
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray6
        contentView.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Configuration
    
    func configure(with message: Message) {
        self.message = message
        
        // 配置头像，基于用户名或昵称选择不同的头像
        let username = message.sender.username
        let nickname = message.sender.nickname ?? ""
        
        if username == "xiaoming" || nickname == "小明" {
            avatarImageView.image = UIImage(named: "avatar1")
            avatarImageView.backgroundColor = nil
        } else if username == "yangguang" || nickname == "阳光" {
            avatarImageView.image = UIImage(named: "avatar2")
            avatarImageView.backgroundColor = nil
        } else if username == "xiaoyu" || nickname == "小鱼" || username == "xiaoai" || nickname == "小爱" {
            avatarImageView.image = UIImage(named: "avatar3")
            avatarImageView.backgroundColor = nil
        } else if username == "daming" || nickname == "大明" {
            avatarImageView.image = UIImage(named: "avatar4")
            avatarImageView.backgroundColor = nil
        } else {
            // 默认头像基于性别
            if message.sender.gender == .female {
                avatarImageView.image = UIImage(named: "avatar3")
                avatarImageView.backgroundColor = nil
            } else {
                avatarImageView.image = UIImage(named: "avatar1")
                avatarImageView.backgroundColor = nil
            }
        }
        
        // 设置名称（优先使用昵称）
        nameLabel.text = message.sender.nickname ?? message.sender.username
        
        // 设置消息预览
        messageLabel.text = message.lastMessage
        
        // 设置时间
        timeLabel.text = message.formattedTime()
        
        // 设置未读角标
        if message.unreadCount > 0 {
            unreadBadge.isHidden = false
            unreadCountLabel.text = "\(message.unreadCount)"
        } else {
            unreadBadge.isHidden = true
        }
    }
} 