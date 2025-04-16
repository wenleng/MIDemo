# MIDemo 聊天交友 App

一款简单的聊天交友应用，参考陌陌的功能设计。这个项目使用 Swift 开发，结合 SnapKit 进行布局、Lottie 实现动画效果，以及 SQLite 作为本地数据存储。

## 功能概述

当前版本实现了以下功能：

1. **用户系统**
   - 本地注册与登录
   - 用户信息存储在 SQLite 数据库中
   - 模拟数据生成

2. **社区互动**
   - 动态展示（模拟数据）
   - 点赞、评论功能（UI 已实现，功能待开发）

3. **用户界面**
   - 登录、注册界面
   - 主页界面
   - 底部标签导航（首页、发现、消息、我的）
   - 底部导航栏粒子烟花效果和震动反馈
   - Lottie 动画过渡效果

## 项目结构

```
MIDemo/
├── Models/            # 数据模型
├── Views/             # 视图组件
├── Controllers/       # 视图控制器
├── Services/          # 服务类
├── Utils/             # 工具类
└── Resources/         # 资源文件
    └── Animations/    # Lottie 动画文件
```

## 运行说明

### 环境需求

- Xcode 13.0+
- iOS 13.0+
- CocoaPods

### 安装步骤

1. 克隆或下载项目到本地

2. 在项目根目录打开终端，安装依赖：
   ```bash
   cd MIDemo
   pod install
   ```

3. 打开生成的 `MIDemo.xcworkspace` 文件

4. 编译并运行项目

### 测试账号

应用启动时会自动生成示例用户数据，您可以使用以下任意账号登录：

- 用户名: `john_doe`, 密码: `password123`
- 用户名: `jane_smith`, 密码: `password123`
- 用户名: `mike_johnson`, 密码: `password123`
- 用户名: `sarah_lee`, 密码: `password123`
- 用户名: `david_wang`, 密码: `password123`

## 第三方库

- [SnapKit](https://github.com/SnapKit/SnapKit) - 简洁的 Swift 自动布局 DSL
- [Lottie](https://github.com/airbnb/lottie-ios) - 用于移动端的动画库

## 未来计划

- 完善个人资料编辑功能
- 实现附近的人功能
- 添加即时消息功能
- 实现社区互动的完整功能
- 添加网络同步功能
