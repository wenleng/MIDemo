//
//  ChatBubbleCell.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class ChatBubbleCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 0.1)
        return imageView
    }()
    
    private let bubbleContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Properties
    
    private var message: ChatMessage?
    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?
    
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
        
        messageLabel.text = nil
        messageImageView.isHidden = true
        messageImageView.image = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Add subviews
        contentView.addSubview(avatarImageView)
        contentView.addSubview(bubbleContainerView)
        contentView.addSubview(timeLabel)
        
        bubbleContainerView.addSubview(messageLabel)
        bubbleContainerView.addSubview(messageImageView)
        
        // Setup constraints
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(36)
        }
        
        bubbleContainerView.snp.makeConstraints { make in
            leadingConstraint = make.leading.equalTo(avatarImageView.snp.trailing).offset(8).constraint
            trailingConstraint = make.trailing.equalToSuperview().offset(-16).constraint
            make.top.equalToSuperview().offset(8)
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.7)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        messageImageView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.lessThanOrEqualTo(200)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(bubbleContainerView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(50)
        }
    }
    
    // MARK: - Configuration
    
    func configure(with message: ChatMessage) {
        self.message = message
        
        // Set message text
        messageLabel.text = message.content
        
        // Set time
        timeLabel.text = message.formattedTime()
        
        // Configure image if present
        if let imageUrl = message.imageUrl {
            messageImageView.isHidden = false
            messageImageView.image = UIImage(named: imageUrl)
            
            // If there's no text, adjust constraints
            if message.content.isEmpty {
                messageLabel.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(0)
                    make.height.equalTo(0)
                    make.left.right.equalToSuperview()
                }
                
                messageImageView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(12)
                    make.right.equalToSuperview().offset(-12)
                    make.height.lessThanOrEqualTo(200)
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
        } else {
            messageImageView.isHidden = true
            
            // Reset message label constraints
            messageLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        
        let isFromCurrentUser = message.isFromCurrentUser
        
        // Style based on sender
        if isFromCurrentUser {
            // Current user messages (right-aligned)
            avatarImageView.isHidden = true
            bubbleContainerView.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 235/255, alpha: 1.0)
            messageLabel.textColor = .black
            
            // Adjust constraints
            leadingConstraint?.deactivate()
            trailingConstraint?.activate()
            
            bubbleContainerView.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.top.equalToSuperview().offset(8)
                make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.7)
            }
            
            timeLabel.snp.remakeConstraints { make in
                make.top.equalTo(bubbleContainerView.snp.bottom).offset(4)
                make.bottom.equalToSuperview().offset(-4)
                make.right.equalTo(bubbleContainerView)
                make.width.equalTo(50)
            }
            
        } else {
            // Other user messages (left-aligned)
            avatarImageView.isHidden = false
            
            // Configure avatar based on gender
            if message.sender.gender == .female {
                avatarImageView.image = UIImage(named: "photo1")
            } else {
                avatarImageView.image = UIImage(named: "photo2")
            }
            
            bubbleContainerView.backgroundColor = .white
            messageLabel.textColor = .black
            
            // Adjust constraints
            trailingConstraint?.deactivate()
            leadingConstraint?.activate()
            
            avatarImageView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.top.equalToSuperview().offset(8)
                make.width.height.equalTo(36)
            }
            
            bubbleContainerView.snp.remakeConstraints { make in
                make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
                make.top.equalToSuperview().offset(8)
                make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.7)
            }
            
            timeLabel.snp.remakeConstraints { make in
                make.top.equalTo(bubbleContainerView.snp.bottom).offset(4)
                make.bottom.equalToSuperview().offset(-4)
                make.left.equalTo(bubbleContainerView)
                make.width.equalTo(50)
            }
        }
        
        // Add extra spacing between messages
        contentView.layoutIfNeeded()
    }
} 