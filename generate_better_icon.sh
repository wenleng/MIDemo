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

echo "开始生成更精美的应用图标(参考微信风格)..."

# 确保目标目录存在
mkdir -p "$ICON_DIR"

# 创建原始1024x1024图标
# 1. 创建渐变背景 - 从上到下的绿色渐变(类似微信的绿色风格，但使用我们自己的品牌色调)
$CONVERT_CMD -size 1024x1024 gradient:#FF4040-#FF6060 \
    -fill none -stroke none \
    -draw "roundrectangle 0,0,1024,1024,230,230" \
    "$ICON_DIR/AppIcon-base.png"

# 2. 应用圆角矩形蒙版
$CONVERT_CMD "$ICON_DIR/AppIcon-base.png" \
    -alpha set -background none \
    \( +clone -alpha extract \
        -draw "roundrectangle 0,0,1024,1024,230,230" \
        -alpha on \
    \) -compose in -composite \
    "$ICON_DIR/AppIcon-rounded.png"

# 3. 创建对话气泡(更圆润的设计，更少的白色)
# 创建一个临时白色圆形，代表主要聊天气泡
$CONVERT_CMD -size 600x600 xc:none \
    -fill white -stroke none \
    -draw "circle 300,300 500,300" \
    "$ICON_DIR/bubble-temp.png"

# 4. 在主图标上合成聊天气泡
$CONVERT_CMD "$ICON_DIR/AppIcon-rounded.png" \
    "$ICON_DIR/bubble-temp.png" -gravity center -composite \
    -fill white -font Arial-Bold -pointsize 240 -gravity center \
    -annotate +0+0 "CM" \
    "$ICON_DIR/AppIcon-1024.png"

# 清理临时文件
rm "$ICON_DIR/AppIcon-base.png" "$ICON_DIR/AppIcon-rounded.png" "$ICON_DIR/bubble-temp.png"

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