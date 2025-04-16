//
//  AuthManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private let defaults = UserDefaults.standard
    private let isLoggedInKey = "isUserLoggedIn"
    private let currentUserIdKey = "currentUserId"
    private let userEmailKey = "userEmail"
    private let userNameKey = "userName"
    private let userNicknameKey = "userNickname"
    
    private(set) var currentUser: User?
    private(set) var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: isLoggedInKey)
        }
        set {
            defaults.setValue(newValue, forKey: isLoggedInKey)
        }
    }
    
    private init() {
        loadUserFromDefaults()
    }
    
    // 登录用户
    func loginUser(_ user: User) {
        currentUser = user
        isLoggedIn = true
        
        // 保存用户信息到UserDefaults
        defaults.setValue(user.id, forKey: currentUserIdKey)
        defaults.setValue(user.email, forKey: userEmailKey)
        defaults.setValue(user.username, forKey: userNameKey)
        defaults.setValue(user.nickname, forKey: userNicknameKey)
        defaults.synchronize()
    }
    
    // 登出用户
    func logoutUser() {
        currentUser = nil
        isLoggedIn = false
        
        // 清除UserDefaults中存储的用户信息
        defaults.removeObject(forKey: currentUserIdKey)
        defaults.removeObject(forKey: userEmailKey)
        defaults.removeObject(forKey: userNameKey)
        defaults.removeObject(forKey: userNicknameKey)
        defaults.synchronize()
    }
    
    // 检查是否已登录
    func isUserLoggedIn() -> Bool {
        return isLoggedIn
    }
    
    // 从UserDefaults加载用户信息
    private func loadUserFromDefaults() {
        if defaults.bool(forKey: isLoggedInKey),
           let userId = defaults.object(forKey: currentUserIdKey) as? Int,
           let email = defaults.string(forKey: userEmailKey),
           let username = defaults.string(forKey: userNameKey) {
            
            let nickname = defaults.string(forKey: userNicknameKey)
            
            // 尝试从数据库获取完整用户信息
            if let savedUser = DatabaseManager.shared.getUserById(id: userId) {
                currentUser = savedUser
            } else {
                // 如果数据库没有，至少从UserDefaults创建一个基本用户对象
                currentUser = User(id: userId, username: username, email: email, password: "", nickname: nickname)
            }
            
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
} 