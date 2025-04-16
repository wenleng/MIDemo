//
//  DatabaseManager.swift
//  MIDemo
//
//  Created for MIDemo
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: OpaquePointer?
    private let dbPath: String = "midemo.sqlite"
    
    private init() {
        self.db = openDatabase()
        createTables()
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer?
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        }
    }
    
    private func createTables() {
        let createUserTableQuery = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            phone_number TEXT,
            password TEXT NOT NULL,
            nickname TEXT,
            avatar TEXT,
            gender TEXT,
            age INTEGER,
            bio TEXT,
            created_at TEXT NOT NULL,
            last_login TEXT
        );
        """
        
        let createUserInterestsTableQuery = """
        CREATE TABLE IF NOT EXISTS user_interests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            interest TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id)
        );
        """
        
        let createUserLocationTableQuery = """
        CREATE TABLE IF NOT EXISTS user_locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            latitude REAL,
            longitude REAL,
            city TEXT,
            country TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id)
        );
        """
        
        // Execute queries
        if executeQuery(query: createUserTableQuery) &&
           executeQuery(query: createUserInterestsTableQuery) &&
           executeQuery(query: createUserLocationTableQuery) {
            print("Successfully created tables")
        } else {
            print("Error creating tables")
        }
    }
    
    private func executeQuery(query: String) -> Bool {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
        }
        
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("Error executing query: \(errorMessage)")
        sqlite3_finalize(statement)
        return false
    }
    
    // MARK: - User Operations
    
    func createUser(username: String, email: String, password: String, phoneNumber: String? = nil) -> User? {
        // Check if user already exists
        if getUserByUsername(username: username) != nil || getUserByEmail(email: email) != nil {
            return nil
        }
        
        let insertUserQuery = """
        INSERT INTO users (username, email, phone_number, password, gender, created_at)
        VALUES (?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertUserQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)
            
            if let phoneNumber = phoneNumber {
                sqlite3_bind_text(statement, 3, (phoneNumber as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 3)
            }
            
            sqlite3_bind_text(statement, 4, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (User.Gender.notSpecified.rawValue as NSString).utf8String, -1, nil)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = dateFormatter.string(from: Date())
            sqlite3_bind_text(statement, 6, (now as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let userId = Int(sqlite3_last_insert_rowid(db))
                sqlite3_finalize(statement)
                return User(id: userId, username: username, email: email, password: password, phoneNumber: phoneNumber)
            } else {
                print("Error inserting user: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing insert user statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    func getUserByUsername(username: String) -> User? {
        let queryString = "SELECT * FROM users WHERE username = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let user = extractUserFromStatement(statement: statement)
                sqlite3_finalize(statement)
                return user
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing get user statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    func getUserByEmail(email: String) -> User? {
        let queryString = "SELECT * FROM users WHERE email = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let user = extractUserFromStatement(statement: statement)
                sqlite3_finalize(statement)
                return user
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing get user statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    func authenticateUser(username: String, password: String) -> User? {
        let queryString = "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let user = extractUserFromStatement(statement: statement)
                
                // Update last login time
                self.updateLastLogin(userId: user.id)
                
                sqlite3_finalize(statement)
                return user
            } else {
                print("User authentication failed")
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing authenticate user statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    private func updateLastLogin(userId: Int) {
        let updateQuery = "UPDATE users SET last_login = ? WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = dateFormatter.string(from: Date())
            
            sqlite3_bind_text(statement, 1, (now as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(userId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating last login: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing update last login statement: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    private func extractUserFromStatement(statement: OpaquePointer?) -> User {
        let id = Int(sqlite3_column_int(statement, 0))
        let username = String(cString: sqlite3_column_text(statement, 1))
        let email = String(cString: sqlite3_column_text(statement, 2))
        
        var phoneNumber: String?
        if sqlite3_column_type(statement, 3) != SQLITE_NULL {
            phoneNumber = String(cString: sqlite3_column_text(statement, 3))
        }
        
        let password = String(cString: sqlite3_column_text(statement, 4))
        
        var nickname: String?
        if sqlite3_column_type(statement, 5) != SQLITE_NULL {
            nickname = String(cString: sqlite3_column_text(statement, 5))
        }
        
        var avatar: String?
        if sqlite3_column_type(statement, 6) != SQLITE_NULL {
            avatar = String(cString: sqlite3_column_text(statement, 6))
        }
        
        let genderString = sqlite3_column_type(statement, 7) != SQLITE_NULL ?
            String(cString: sqlite3_column_text(statement, 7)) : User.Gender.notSpecified.rawValue
        let gender = User.Gender(rawValue: genderString) ?? .notSpecified
        
        var age: Int?
        if sqlite3_column_type(statement, 8) != SQLITE_NULL {
            age = Int(sqlite3_column_int(statement, 8))
        }
        
        var bio: String?
        if sqlite3_column_type(statement, 9) != SQLITE_NULL {
            bio = String(cString: sqlite3_column_text(statement, 9))
        }
        
        let createdAtString = String(cString: sqlite3_column_text(statement, 10))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createdAt = dateFormatter.date(from: createdAtString) ?? Date()
        
        var lastLoginAt: Date?
        if sqlite3_column_type(statement, 11) != SQLITE_NULL {
            let lastLoginString = String(cString: sqlite3_column_text(statement, 11))
            lastLoginAt = dateFormatter.date(from: lastLoginString)
        }
        
        // Create basic user
        var user = User(id: id, username: username, email: email, password: password, phoneNumber: phoneNumber,
                        nickname: nickname, avatar: avatar, gender: gender, age: age, bio: bio)
        
        // Set dates
        user.createdAt = createdAt
        user.lastLoginAt = lastLoginAt
        
        // Get user interests
        user.interests = getUserInterests(userId: id)
        
        // Get user location
        user.location = getUserLocation(userId: id)
        
        return user
    }
    
    private func getUserInterests(userId: Int) -> [String]? {
        let queryString = "SELECT interest FROM user_interests WHERE user_id = ?;"
        var statement: OpaquePointer?
        var interests: [String] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let interest = String(cString: sqlite3_column_text(statement, 0))
                interests.append(interest)
            }
            
            sqlite3_finalize(statement)
            return interests.isEmpty ? nil : interests
        } else {
            print("Error preparing get user interests statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    private func getUserLocation(userId: Int) -> User.Location? {
        let queryString = "SELECT latitude, longitude, city, country FROM user_locations WHERE user_id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let latitude = sqlite3_column_double(statement, 0)
                let longitude = sqlite3_column_double(statement, 1)
                
                var city: String?
                if sqlite3_column_type(statement, 2) != SQLITE_NULL {
                    city = String(cString: sqlite3_column_text(statement, 2))
                }
                
                var country: String?
                if sqlite3_column_type(statement, 3) != SQLITE_NULL {
                    country = String(cString: sqlite3_column_text(statement, 3))
                }
                
                sqlite3_finalize(statement)
                return User.Location(latitude: latitude, longitude: longitude, city: city, country: country)
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing get user location statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    // MARK: - Sample Data
    
    func generateSampleUsers() {
        // Only generate if no users exist
        let queryString = "SELECT COUNT(*) FROM users;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let count = sqlite3_column_int(statement, 0)
                sqlite3_finalize(statement)
                
                if count > 0 {
                    print("Sample users already exist")
                    return
                }
            }
        }
        
        // Sample users
        let users = [
            (username: "john_doe", email: "john@example.com", password: "password123", gender: User.Gender.male, age: 28),
            (username: "jane_smith", email: "jane@example.com", password: "password123", gender: User.Gender.female, age: 25),
            (username: "mike_johnson", email: "mike@example.com", password: "password123", gender: User.Gender.male, age: 32),
            (username: "sarah_lee", email: "sarah@example.com", password: "password123", gender: User.Gender.female, age: 27),
            (username: "david_wang", email: "david@example.com", password: "password123", gender: User.Gender.male, age: 30),
        ]
        
        for user in users {
            if let newUser = createUser(username: user.username, email: user.email, password: user.password) {
                // Update gender and age
                updateUserProfile(userId: newUser.id, gender: user.gender, age: user.age)
                
                // Add some interests
                addUserInterests(userId: newUser.id, interests: getRandomInterests())
                
                // Add location
                addUserLocation(userId: newUser.id, location: getRandomLocation())
            }
        }
        
        print("Successfully generated sample users")
    }
    
    private func updateUserProfile(userId: Int, gender: User.Gender, age: Int) {
        let updateQuery = "UPDATE users SET gender = ?, age = ? WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (gender.rawValue as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(age))
            sqlite3_bind_int(statement, 3, Int32(userId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating user profile: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    private func addUserInterests(userId: Int, interests: [String]) {
        for interest in interests {
            let insertQuery = "INSERT INTO user_interests (user_id, interest) VALUES (?, ?);"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(userId))
                sqlite3_bind_text(statement, 2, (interest as NSString).utf8String, -1, nil)
                
                if sqlite3_step(statement) != SQLITE_DONE {
                    print("Error adding user interest: \(String(cString: sqlite3_errmsg(db)))")
                }
                
                sqlite3_finalize(statement)
            }
        }
    }
    
    private func addUserLocation(userId: Int, location: User.Location) {
        let insertQuery = "INSERT INTO user_locations (user_id, latitude, longitude, city, country) VALUES (?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            sqlite3_bind_double(statement, 2, location.latitude)
            sqlite3_bind_double(statement, 3, location.longitude)
            
            if let city = location.city {
                sqlite3_bind_text(statement, 4, (city as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 4)
            }
            
            if let country = location.country {
                sqlite3_bind_text(statement, 5, (country as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 5)
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error adding user location: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    private func getRandomInterests() -> [String] {
        let allInterests = [
            "Travel", "Photography", "Cooking", "Music", "Movies", "Reading",
            "Sports", "Gaming", "Art", "Technology", "Fashion", "Fitness",
            "Dancing", "Writing", "Hiking", "Yoga", "Pets", "Gardening"
        ]
        
        let count = Int.random(in: 2...5)
        var selectedInterests: [String] = []
        
        while selectedInterests.count < count {
            if let interest = allInterests.randomElement(), !selectedInterests.contains(interest) {
                selectedInterests.append(interest)
            }
        }
        
        return selectedInterests
    }
    
    private func getRandomLocation() -> User.Location {
        // Random locations in major cities
        let locations = [
            (lat: 40.7128, lon: -74.0060, city: "New York", country: "USA"),
            (lat: 34.0522, lon: -118.2437, city: "Los Angeles", country: "USA"),
            (lat: 51.5074, lon: -0.1278, city: "London", country: "UK"),
            (lat: 48.8566, lon: 2.3522, city: "Paris", country: "France"),
            (lat: 35.6762, lon: 139.6503, city: "Tokyo", country: "Japan"),
            (lat: 39.9042, lon: 116.4074, city: "Beijing", country: "China"),
            (lat: -33.8688, lon: 151.2093, city: "Sydney", country: "Australia")
        ]
        
        let location = locations.randomElement()!
        return User.Location(latitude: location.lat, longitude: location.lon, city: location.city, country: location.country)
    }
    
    func getUserById(id: Int) -> User? {
        let queryString = "SELECT * FROM users WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let user = extractUserFromStatement(statement: statement)
                sqlite3_finalize(statement)
                return user
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing get user statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
} 