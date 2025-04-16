//
//  ProfileStatsView.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class ProfileStatsView: UIView {
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    init(title: String, count: Int) {
        super.init(frame: .zero)
        setupUI()
        
        titleLabel.text = title
        countLabel.text = "\(count)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(countLabel)
        addSubview(titleLabel)
        
        countLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(countLabel.snp.bottom).offset(4)
        }
    }
} 