//
//  Message.swift
//  MIDemo
//
//  Created for MIDemo
//

import Foundation

struct Message {
    let id: Int
    let sender: User
    let receiver: User
    let lastMessage: String
    let unreadCount: Int
    let timestamp: Date
    
    // Helper function to format timestamp
    func formattedTime() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(timestamp) {
            // If today, show time
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: timestamp)
        } else if calendar.isDateInYesterday(timestamp) {
            // If yesterday
            return "昨天"
        } else if calendar.dateComponents([.day], from: timestamp, to: now).day! < 7 {
            // If within a week
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "zh_CN")
            return formatter.string(from: timestamp)
        } else {
            // More than a week ago
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd"
            return formatter.string(from: timestamp)
        }
    }
}

// Chat message structure for individual messages in a conversation
struct ChatMessage {
    let id: Int
    let sender: User
    let content: String
    let timestamp: Date
    let isRead: Bool
    
    // For image messages
    let imageUrl: String?
    
    init(id: Int, sender: User, content: String, timestamp: Date = Date(), isRead: Bool = false, imageUrl: String? = nil) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.isRead = isRead
        self.imageUrl = imageUrl
    }
    
    // Returns true if this message was sent by the current user
    var isFromCurrentUser: Bool {
        return sender.id == User.currentUser.id
    }
    
    // Helper function to format timestamp for chat messages
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
}

// For Storyboard previews and testing
extension User {
    // Mock current user
    static let currentUser = User(
        id: 0,
        username: "currentuser",
        email: "me@example.com",
        password: "",
        nickname: "我",
        gender: .male,
        age: 25
    )
} 