//
//  ProfilePostsViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class ProfilePostsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["动态", "相册", "关于我"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = UIColor(red: 255/255, green: 85/255, blue: 85/255, alpha: 1.0)
        control.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return control
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    private var posts: [Post] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        loadSampleData()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(36)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(AboutMeCell.self, forCellWithReuseIdentifier: "AboutMeCell")
    }
    
    private func loadSampleData() {
        // Create sample user
        let currentUser = User(id: 1, username: "myusername", email: "user@example.com", 
                             password: "", nickname: "我的昵称", gender: .female, age: 28)
        
        // Create sample post
        let post = Post(
            id: 1,
            user: currentUser,
            content: "分享一张我最近拍的照片，喜欢摄影的朋友可以交流~",
            images: ["photo1", "photo2", "photo3", "photo4"],
            likes: 12,
            comments: [],
            createdAt: Date().addingTimeInterval(-24 * 3600) // 1 day ago
        )
        
        posts = [post]
        // Add more posts as needed
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension ProfilePostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 动态
            return posts.count
        case 1: // 相册
            return 6 // 示例相册数量
        case 2: // 关于我
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 动态
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! ProfilePostCell
            cell.configure(with: posts[indexPath.item])
            return cell
        case 1: // 相册
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            // Use our test photos (cycling through photo1, photo2, photo3, photo4)
            let photoIndex = (indexPath.item % 4) + 1
            cell.configure(with: "photo\(photoIndex)")
            return cell
        case 2: // 关于我
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutMeCell", for: indexPath) as! AboutMeCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 动态
            return CGSize(width: width, height: 400) // 动态的高度可以根据内容自适应
        case 1: // 相册
            let photoWidth = (width - 2) / 3 // 3列，间距1
            return CGSize(width: photoWidth, height: photoWidth)
        case 2: // 关于我
            return CGSize(width: width, height: 200)
        default:
            return .zero
        }
    }
} 