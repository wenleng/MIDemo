//
//  SettingsViewController.swift
//  MIDemo
//
//  Created for MIDemo
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .systemGray6
        tv.separatorStyle = .none
        return tv
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    private let settingsItems: [[SettingsItem]] = [
        [
            SettingsItem(title: "账号与安全", icon: "person.circle.fill", rightText: nil),
            SettingsItem(title: "隐私设置", icon: "lock.fill", rightText: nil),
            SettingsItem(title: "通知设置", icon: "bell.fill", rightText: nil)
        ],
        [
            SettingsItem(title: "语言", icon: "globe", rightText: "简体中文"),
            SettingsItem(title: "深色模式", icon: "moon.fill", rightText: "关闭"),
            SettingsItem(title: "清除缓存", icon: "trash.fill", rightText: "23.5MB")
        ],
        [
            SettingsItem(title: "帮助与反馈", icon: "questionmark.circle.fill", rightText: nil),
            SettingsItem(title: "关于我们", icon: "info.circle.fill", rightText: "v1.0.0")
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏底部标签栏
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 显示底部标签栏
        tabBarController?.tabBar.isHidden = false
    }

    private func setupUI() {
        title = "设置"
        view.backgroundColor = .systemGray6

        // 设置导航栏样式
        navigationController?.navigationBar.setupAppearance()
        navigationController?.navigationBar.restoreShadow() // 确保设置页面显示阴影

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )

        view.addSubview(tableView)
        view.addSubview(logoutButton)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(logoutButton.snp.top).offset(-20)
        }

        logoutButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
    }

    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func logoutButtonTapped() {
        showLogoutAlert()
    }

    private func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "退出登录",
            message: "确定要退出登录吗？",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(
            title: "取消",
            style: .cancel
        ))

        alertController.addAction(UIAlertAction(
            title: "确定",
            style: .destructive
        ) { [weak self] _ in
            // 使用AuthManager处理登出逻辑
            AuthManager.shared.logoutUser()

            // 返回到登录页面
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen

            // 使用当前导航控制器所在的主窗口呈现登录页面
            UIApplication.shared.windows.first?.rootViewController = navController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })

        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let item = settingsItems[indexPath.section][indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = settingsItems[indexPath.section][indexPath.row]

        switch item.title {
        case "清除缓存":
            // 实现清除缓存功能
            break
        case "语言":
            // 实现语言切换功能
            break
        case "深色模式":
            // 实现深色模式切换功能
            break
        default:
            break
        }
    }
}

// MARK: - SettingsItem Model
struct SettingsItem {
    let title: String
    let icon: String
    let rightText: String?
}

// MARK: - SettingsCell
class SettingsCell: UITableViewCell {

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray2
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        return label
    }()

    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(arrowImageView)

        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }

        rightLabel.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with item: SettingsItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        rightLabel.text = item.rightText
        rightLabel.isHidden = item.rightText == nil
    }
}