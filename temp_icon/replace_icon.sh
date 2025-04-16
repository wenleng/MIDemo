#!/bin/bash

# 定义路径
ICON_DIR="./MIDemo/Assets.xcassets/AppIcon.appiconset"
SOURCE_ICON="$ICON_DIR/AppIcon.png"

# 检测ImageMagick命令
if command -v magick &> /dev/null; then
    CONVERT_CMD="magick"
elif command -v convert &> /dev/null; then
    CONVERT_CMD="convert"
else
    echo "❌ 错误: 未找到ImageMagick命令。请安装ImageMagick后再试。"
    exit 1
fi

echo "开始生成所有尺寸的应用图标..."

# 确保源图像存在
if [ ! -f "$SOURCE_ICON" ]; then
    echo "❌ 错误: 源图像 $SOURCE_ICON 不存在"
    exit 1
fi

# 复制图像到AppIcon-1024.png
cp "$SOURCE_ICON" "$ICON_DIR/AppIcon-1024.png"

# 验证图像
echo "验证图像尺寸和类型..."
$CONVERT_CMD "$SOURCE_ICON" -format "%wx%h %m" info:-

# 生成所有其他尺寸的图标
echo "生成 AppIcon-20@2x.png (40x40)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 40x40 "$ICON_DIR/AppIcon-20@2x.png"

echo "生成 AppIcon-20@3x.png (60x60)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 60x60 "$ICON_DIR/AppIcon-20@3x.png"

echo "生成 AppIcon-29@2x.png (58x58)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 58x58 "$ICON_DIR/AppIcon-29@2x.png"

echo "生成 AppIcon-29@3x.png (87x87)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 87x87 "$ICON_DIR/AppIcon-29@3x.png"

echo "生成 AppIcon-40@2x.png (80x80)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 80x80 "$ICON_DIR/AppIcon-40@2x.png"

echo "生成 AppIcon-40@3x.png (120x120)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 120x120 "$ICON_DIR/AppIcon-40@3x.png"

echo "生成 AppIcon-60@2x.png (120x120)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 120x120 "$ICON_DIR/AppIcon-60@2x.png"

echo "生成 AppIcon-60@3x.png (180x180)..."
$CONVERT_CMD "$SOURCE_ICON" -resize 180x180 "$ICON_DIR/AppIcon-60@3x.png"

# 检查生成是否成功
ICON_FILES=(
    "AppIcon-20@2x.png"
    "AppIcon-20@3x.png"
    "AppIcon-29@2x.png"
    "AppIcon-29@3x.png"
    "AppIcon-40@2x.png"
    "AppIcon-40@3x.png"
    "AppIcon-60@2x.png"
    "AppIcon-60@3x.png"
    "AppIcon-1024.png"
    "AppIcon.png"
)

echo "检查图标文件..."
SUCCESS=true

for ICON_NAME in "${ICON_FILES[@]}"; do
    if [ ! -f "$ICON_DIR/$ICON_NAME" ]; then
        echo "❌ 未找到图标: $ICON_NAME"
        SUCCESS=false
    fi
done

if [ "$SUCCESS" = true ]; then
    echo "✅ 所有图标文件已成功生成!"
    echo "图标路径: $(cd "$(dirname "$ICON_DIR")" && pwd)/$(basename "$ICON_DIR")"
    
    # 打开包含图标的文件夹
    open "$ICON_DIR"
else
    echo "❌ 部分图标生成失败"
fi 