#!/bin/bash

# 定义路径
ICON_DIR="./MIDemo/Assets.xcassets/AppIcon.appiconset"

# 检测ImageMagick命令
if command -v magick &> /dev/null; then
    # 使用magick命令（ImageMagick v7）
    CONVERT_CMD="magick"
elif command -v convert &> /dev/null; then
    # 回退到convert命令（旧版ImageMagick）
    CONVERT_CMD="convert"
else
    echo "❌ 错误: 未找到ImageMagick命令。请安装ImageMagick后再试。"
    exit 1
fi

echo "开始生成应用图标..."

# 确保目标目录存在
mkdir -p "$ICON_DIR"

# 创建应用图标 - 1024x1024尺寸，红色背景，带聊天气泡图案
$CONVERT_CMD -size 1024x1024 xc:'#FF5555' \
    -fill white -stroke white -strokewidth 10 \
    -draw "roundrectangle 0,0,1024,1024,230,230" \
    "$ICON_DIR/AppIcon.png"

# 添加聊天气泡
$CONVERT_CMD "$ICON_DIR/AppIcon.png" \
    -fill white \
    -draw "roundrectangle 256,358,586,578,41,41" \
    -draw "roundrectangle 460,481,790,701,41,41" \
    "$ICON_DIR/AppIcon.png"

# 添加文字 "CM"
$CONVERT_CMD "$ICON_DIR/AppIcon.png" \
    -fill white \
    -pointsize 204 \
    -gravity center \
    -annotate +0+123 "CM" \
    "$ICON_DIR/AppIcon.png"

# 创建Contents.json文件
cat > "$ICON_DIR/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "AppIcon.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# 检查生成是否成功
if [ -f "$ICON_DIR/AppIcon.png" ]; then
    echo "✅ 应用图标已成功生成!"
    echo "图标路径: $(cd "$(dirname "$ICON_DIR")" && pwd)/$(basename "$ICON_DIR")"
    
    # 打开包含图标的文件夹
    open "$ICON_DIR"
else
    echo "❌ 应用图标生成失败"
fi 