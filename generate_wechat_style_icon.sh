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

echo "开始生成微信风格的应用图标..."

# 确保目标目录存在
mkdir -p "$ICON_DIR"

# 创建原始1024x1024图标
# 1. 创建绿色背景(微信风格的绿色)
$CONVERT_CMD -size 1024x1024 xc:'#07C160' \
    "$ICON_DIR/AppIcon-base.png"

# 2. 创建圆角矩形蒙版
$CONVERT_CMD "$ICON_DIR/AppIcon-base.png" \
    -alpha set -background none \
    \( +clone -alpha extract \
        -draw "roundrectangle 0,0,1024,1024,230,230" \
        -alpha on \
    \) -compose in -composite \
    "$ICON_DIR/AppIcon-rounded.png"

# 3. 创建双对话气泡(更像微信的设计)
# 创建一个临时图像，带有两个对话气泡
$CONVERT_CMD -size 800x800 xc:none \
    -fill white -stroke none \
    -draw "circle 350,350 550,350" \
    -draw "circle 550,550 350,550" \
    "$ICON_DIR/bubbles-temp.png"

# 4. 将气泡添加到主图标
$CONVERT_CMD "$ICON_DIR/AppIcon-rounded.png" \
    "$ICON_DIR/bubbles-temp.png" -gravity center -composite \
    "$ICON_DIR/AppIcon-1024.png"

# 清理临时文件
rm "$ICON_DIR/AppIcon-base.png" "$ICON_DIR/AppIcon-rounded.png" "$ICON_DIR/bubbles-temp.png"

# 复制一份做备份
cp "$ICON_DIR/AppIcon-1024.png" "$ICON_DIR/AppIcon.png"

# 生成所有其他尺寸的图标
echo "生成 AppIcon-20@2x.png (40x40)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 40x40 "$ICON_DIR/AppIcon-20@2x.png"

echo "生成 AppIcon-20@3x.png (60x60)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 60x60 "$ICON_DIR/AppIcon-20@3x.png"

echo "生成 AppIcon-29@2x.png (58x58)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 58x58 "$ICON_DIR/AppIcon-29@2x.png"

echo "生成 AppIcon-29@3x.png (87x87)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 87x87 "$ICON_DIR/AppIcon-29@3x.png"

echo "生成 AppIcon-40@2x.png (80x80)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 80x80 "$ICON_DIR/AppIcon-40@2x.png"

echo "生成 AppIcon-40@3x.png (120x120)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 120x120 "$ICON_DIR/AppIcon-40@3x.png"

echo "生成 AppIcon-60@2x.png (120x120)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 120x120 "$ICON_DIR/AppIcon-60@2x.png"

echo "生成 AppIcon-60@3x.png (180x180)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 180x180 "$ICON_DIR/AppIcon-60@3x.png"

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