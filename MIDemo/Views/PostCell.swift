//
//  PostCell.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class PostCell: UITableViewCell {

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 0.1)
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .gray
        return button
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    private let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    private let commentsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        return view
    }()

    private let commentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let actionsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setTitle(" 点赞", for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()

    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.setTitle(" 评论", for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()

    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.setTitle(" 分享", for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()

    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()

    // MARK: - Properties

    private var post: Post?

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

        // 清除图片视图
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 清除评论视图
        commentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 重置点赞按钮状态
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
        likeButton.setTitle(" 点赞", for: .normal)
    }

    // MARK: - Setup Methods

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        // 添加子视图
        contentView.addSubview(containerView)

        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(moreButton)
        containerView.addSubview(contentLabel)
        containerView.addSubview(imagesStackView)
        containerView.addSubview(commentsView)
        commentsView.addSubview(commentsStackView)

        containerView.addSubview(dividerView)
        containerView.addSubview(actionsView)

        actionsView.addSubview(likeButton)
        actionsView.addSubview(commentButton)
        actionsView.addSubview(shareButton)

        // 设置约束
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-8)
        }

        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(44)
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.top.equalTo(avatarImageView).offset(2)
        }

        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(avatarImageView)
            make.width.height.equalTo(30)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }

        imagesStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            make.height.equalTo(0) // 默认高度为0，在有图片时动态调整
        }

        commentsView.snp.makeConstraints { make in
            make.top.equalTo(imagesStackView.snp.bottom).offset(12)
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
        }

        commentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }

        dividerView.snp.makeConstraints { make in
            make.top.equalTo(commentsView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }

        actionsView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }

        let buttonWidth = UIScreen.main.bounds.width / 3 - 30

        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(buttonWidth/2)
            make.width.lessThanOrEqualTo(buttonWidth)
        }

        commentButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(buttonWidth)
        }

        shareButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-buttonWidth/2)
            make.width.lessThanOrEqualTo(buttonWidth)
        }
    }

    // MARK: - Configuration

    func configure(with post: Post) {
        self.post = post

        // 设置用户信息
        nameLabel.text = post.user.nickname ?? post.user.username

        // 设置时间标签
        timeLabel.text = formatTimeAgo(from: post.createdAt)

        // 设置内容
        contentLabel.text = post.content

        // 设置图片
        setupImages(with: post.images)

        // 设置评论
        setupComments(with: post.comments)

        // 设置点赞数
        if post.likes > 0 {
            likeButton.setTitle(" \(post.likes)", for: .normal)
        } else {
            likeButton.setTitle(" 点赞", for: .normal)
        }

        // 设置评论数
        if post.comments.count > 0 {
            commentButton.setTitle(" \(post.comments.count)", for: .normal)
        } else {
            commentButton.setTitle(" 评论", for: .normal)
        }
    }

    private func setupImages(with images: [String]) {
        // 清除现有图片
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if images.isEmpty {
            imagesStackView.snp.remakeConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(12)
                make.left.equalTo(contentLabel)
                make.right.equalTo(contentLabel)
                make.height.equalTo(0)
            }
            return
        }

        // 计算图片高度
        var imageHeight: CGFloat = 0

        if images.count == 1 {
            imageHeight = 200
        } else if images.count <= 3 {
            imageHeight = 120
        } else {
            imageHeight = 240 // 如果多于3张，分成两行显示
        }

        imagesStackView.snp.remakeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            make.height.equalTo(imageHeight)
        }

        // 调试信息
        print("设置图片，数量: \(images.count), 高度: \(imageHeight)")

        // 如果图片超过3张，改变堆栈视图方向为垂直
        if images.count > 3 {
            imagesStackView.axis = .vertical
            imagesStackView.distribution = .fillEqually

            // 创建两个子堆栈视图
            let topRow = UIStackView()
            topRow.axis = .horizontal
            topRow.distribution = .fillEqually
            topRow.spacing = 5

            let bottomRow = UIStackView()
            bottomRow.axis = .horizontal
            bottomRow.distribution = .fillEqually
            bottomRow.spacing = 5

            imagesStackView.addArrangedSubview(topRow)
            imagesStackView.addArrangedSubview(bottomRow)

            // 添加图片到行
            for (index, imageName) in images.enumerated() {
                if index >= 6 { break } // 最多显示6张图片

                let imageView = createImageView(with: imageName)

                if index < 3 {
                    topRow.addArrangedSubview(imageView)
                } else {
                    bottomRow.addArrangedSubview(imageView)
                }
            }
        } else {
            // 3张或更少的图片，横向显示
            imagesStackView.axis = .horizontal

            for (index, imageName) in images.enumerated() {
                if index >= 3 { break } // 最多显示3张图片

                let imageView = createImageView(with: imageName)
                imagesStackView.addArrangedSubview(imageView)
            }
        }
    }

    private func createImageView(with imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        // Prioritize using test photos (photo1, photo2, photo3, photo4)
        if imageName.hasPrefix("photo") {
            if let image = UIImage(named: imageName) {
                imageView.image = image
                print("成功加载测试图片: \(imageName)")
            } else {
                // Fallback to photo1 if specific test image not found
                imageView.image = UIImage(named: "photo1")
                print("未找到测试图片 \(imageName)，使用默认测试图片")
            }
        } else if let systemImage = UIImage(systemName: imageName) {
            // Use system images as fallback
            imageView.image = systemImage
            imageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
            print("使用系统图标: \(imageName)")
        } else {
            // Use photo1 as final fallback
            imageView.image = UIImage(named: "photo1") ?? UIImage(systemName: "photo")
            print("无法加载图片或图标: \(imageName)，使用默认测试图片")
        }

        return imageView
    }

    private func setupComments(with comments: [Comment]) {
        // 清除现有评论
        commentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if comments.isEmpty {
            commentsView.isHidden = true
            commentsView.snp.remakeConstraints { make in
                make.top.equalTo(imagesStackView.snp.bottom).offset(12)
                make.left.equalTo(contentLabel)
                make.right.equalTo(contentLabel)
                make.height.equalTo(0)
            }
        } else {
            commentsView.isHidden = false
            commentsView.snp.remakeConstraints { make in
                make.top.equalTo(imagesStackView.snp.bottom).offset(12)
                make.left.equalTo(contentLabel)
                make.right.equalTo(contentLabel)
            }

            for comment in comments {
                let commentView = createCommentView(comment: comment)
                commentsStackView.addArrangedSubview(commentView)
            }
        }
    }

    private func createCommentView(comment: Comment) -> UIView {
        let commentView = UIView()

        // 创建头像视图
        let avatarSize: CGFloat = 24
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarSize / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 0.1)
        avatarImageView.image = UIImage(systemName: "person.circle")
        avatarImageView.tintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)

        // 创建用户名标签
        let usernameLabel = UILabel()
        usernameLabel.text = comment.user.nickname ?? comment.user.username
        usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        usernameLabel.textColor = .black

        // 创建内容标签
        let contentLabel = UILabel()
        contentLabel.text = comment.content
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .darkGray
        contentLabel.numberOfLines = 0

        // 创建时间标签
        let timeLabel = UILabel()
        timeLabel.text = formatTimeAgo(from: comment.createdAt)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .gray

        // 添加子视图
        commentView.addSubview(avatarImageView)
        commentView.addSubview(usernameLabel)
        commentView.addSubview(contentLabel)
        commentView.addSubview(timeLabel)

        // 设置约束
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(2)
            make.top.equalToSuperview().offset(2)
            make.width.height.equalTo(avatarSize)
        }

        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(8)
            make.top.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(usernameLabel.snp.right).offset(8)
            make.centerY.equalTo(usernameLabel)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.left.equalTo(usernameLabel)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }

        return commentView
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