//
//  Post.swift
//  MIDemo
//
//  Created for MIDemo
//

import Foundation

struct Post {
    let id: Int
    let user: User
    let content: String
    let images: [String]
    let location: String?
    let mentions: [User]?
    let likes: Int
    let comments: [Comment]
    let createdAt: Date
    
    init(id: Int, user: User, content: String, images: [String], location: String? = nil, mentions: [User]? = nil, likes: Int = 0, comments: [Comment] = [], createdAt: Date = Date()) {
        self.id = id
        self.user = user
        self.content = content
        self.images = images
        self.location = location
        self.mentions = mentions
        self.likes = likes
        self.comments = comments
        self.createdAt = createdAt
    }
}

struct Comment: Codable {
    let id: Int
    let user: User
    let content: String
    let createdAt: Date
    
    init(id: Int, user: User, content: String, createdAt: Date = Date()) {
        self.id = id
        self.user = user
        self.content = content
        self.createdAt = createdAt
    }
} 