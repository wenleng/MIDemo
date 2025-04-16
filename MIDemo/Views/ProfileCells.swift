//
//  ProfileCells.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class ProfilePostCell: UICollectionViewCell {
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemGray
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
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.top.equalTo(avatarImageView)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(usernameLabel)
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
        }
        
        postImageView.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.height.equalTo(200)
        }
        
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        commentButton.snp.makeConstraints { make in
            make.left.equalTo(likeButton.snp.right).offset(24)
            make.centerY.equalTo(likeButton)
        }
        
        shareButton.snp.makeConstraints { make in
            make.left.equalTo(commentButton.snp.right).offset(24)
            make.centerY.equalTo(likeButton)
        }
    }
    
    func configure(with post: Post) {
        // Use system icon for avatar if no custom image exists
        if let avatarImage = UIImage(systemName: "person.circle.fill") {
            avatarImageView.image = avatarImage
        }
        
        // Display nickname or username
        usernameLabel.text = post.user.nickname ?? post.user.username
        
        // Format timestamp
        timeLabel.text = formatTimeAgo(from: post.createdAt)
        
        // Set content
        contentLabel.text = post.content
        
        // Set first image if available
        if let image = post.images.first {
            if image.hasPrefix("photo") {
                postImageView.image = UIImage(named: image)
            } else {
                // Fallback to test image
                postImageView.image = UIImage(named: "photo1")
            }
        } else {
            // Default test image if no images are available
            postImageView.image = UIImage(named: "photo1")
        }
        
        // Set like and comment counts
        likeButton.setTitle(" \(post.likes)", for: .normal)
        commentButton.setTitle(" \(post.comments.count)", for: .normal)
    }
    
    private func formatTimeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)天前"
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour)小时前"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute)分钟前"
        }
        
        return "刚刚"
    }
}

class PhotoCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with imageName: String) {
        // Prioritize using test photos if the imageName starts with "photo"
        if imageName.hasPrefix("photo") {
            imageView.image = UIImage(named: imageName)
        } else {
            // Fallback to a default test image if the specified name isn't available
            imageView.image = UIImage(named: "photo1")
        }
    }
}

class AboutMeCell: UICollectionViewCell {
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = "这是我的个性签名，展示我的特点和个性。"
        return label
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
        contentView.addSubview(bioLabel)
        bioLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
} 