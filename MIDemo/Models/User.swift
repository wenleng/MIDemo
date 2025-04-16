//
//  User.swift
//  MIDemo
//
//  Created for MIDemo
//

import Foundation

struct User: Codable {
    let id: Int
    var username: String
    var email: String
    var phoneNumber: String?
    var password: String
    var nickname: String?
    var avatar: String?
    var gender: Gender
    var age: Int?
    var bio: String?
    var interests: [String]?
    var location: Location?
    var createdAt: Date
    var lastLoginAt: Date?

    enum Gender: String, Codable {
        case male = "male"
        case female = "female"
        case other = "other"
        case notSpecified = "not_specified"
    }

    struct Location: Codable {
        var latitude: Double
        var longitude: Double
        var city: String?
        var country: String?
    }

    init(id: Int, username: String, email: String, password: String, phoneNumber: String? = nil,
         nickname: String? = nil, avatar: String? = nil, gender: Gender = .notSpecified,
         age: Int? = nil, bio: String? = nil, interests: [String]? = nil, location: Location? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.nickname = nickname
        self.avatar = avatar
        self.gender = gender
        self.age = age
        self.bio = bio
        self.interests = interests
        self.location = location
        self.createdAt = Date()
        self.lastLoginAt = nil
    }

    // 注意: currentUser 已经在 Message.swift 中定义
}