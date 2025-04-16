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

echo "开始生成精确匹配的应用图标..."

# 确保目标目录存在
mkdir -p "$ICON_DIR"

# 定义颜色 - 精确匹配图片中的粉红色
# 强制使用RGB颜色空间并确保正确引用颜色
PINK_COLOR="rgb(255,91,102)"

echo "使用的颜色: $PINK_COLOR"

# 创建原始1024x1024图标
# 1. 创建纯色背景，确保使用RGB颜色空间
$CONVERT_CMD -size 1024x1024 xc:"$PINK_COLOR" \
    -colorspace sRGB \
    "$ICON_DIR/AppIcon-base.png"

# 验证基础图像的颜色
echo "验证基础图像颜色..."
$CONVERT_CMD "$ICON_DIR/AppIcon-base.png" -format "%[pixel:p{0,0}]" info:-

# 2. 创建圆形蒙版
$CONVERT_CMD "$ICON_DIR/AppIcon-base.png" \
    -alpha set -background none \
    \( +clone -alpha extract \
        -draw "circle 512,512 512,0" \
        -alpha on \
    \) -compose in -composite \
    -colorspace sRGB \
    "$ICON_DIR/AppIcon-circle.png"

# 3. 创建对话气泡 - 确保与示例图片一致
# 主对话气泡(简单圆形，位置略靠左上)
$CONVERT_CMD -size 800x800 xc:none \
    -fill white -stroke none \
    -draw "circle 390,380 550,380" \
    -colorspace sRGB \
    "$ICON_DIR/bubble.png"

# 4. 将气泡添加到主图标，确保保留颜色空间
$CONVERT_CMD "$ICON_DIR/AppIcon-circle.png" \
    "$ICON_DIR/bubble.png" -gravity center -composite \
    -colorspace sRGB \
    "$ICON_DIR/AppIcon-with-bubble.png"

# 5. 添加一个小圆点做为第二个气泡(如图片所示)
$CONVERT_CMD -size 800x800 xc:none \
    -fill white -stroke none \
    -draw "circle 450,450 470,450" \
    -colorspace sRGB \
    "$ICON_DIR/bubble-dot.png"

# 将小气泡添加到主图标
$CONVERT_CMD "$ICON_DIR/AppIcon-with-bubble.png" \
    "$ICON_DIR/bubble-dot.png" -gravity center -composite \
    -colorspace sRGB \
    "$ICON_DIR/AppIcon-1024.png"

# 验证颜色是否正确应用
echo "验证最终图标颜色..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -format "%[pixel:p{512,0}]" info:-

# 检查并确保图标是彩色而不是黑白
echo "检查颜色空间..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -format "%[colorspace]" info:-

# 清理临时文件
rm "$ICON_DIR/AppIcon-base.png" "$ICON_DIR/AppIcon-circle.png" "$ICON_DIR/bubble.png" "$ICON_DIR/bubble-dot.png" "$ICON_DIR/AppIcon-with-bubble.png"

# 复制一份做备份
cp "$ICON_DIR/AppIcon-1024.png" "$ICON_DIR/AppIcon.png"

# 生成所有其他尺寸的图标，保留颜色空间
echo "生成 AppIcon-20@2x.png (40x40)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 40x40 -colorspace sRGB "$ICON_DIR/AppIcon-20@2x.png"

echo "生成 AppIcon-20@3x.png (60x60)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 60x60 -colorspace sRGB "$ICON_DIR/AppIcon-20@3x.png"

echo "生成 AppIcon-29@2x.png (58x58)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 58x58 -colorspace sRGB "$ICON_DIR/AppIcon-29@2x.png"

echo "生成 AppIcon-29@3x.png (87x87)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 87x87 -colorspace sRGB "$ICON_DIR/AppIcon-29@3x.png"

echo "生成 AppIcon-40@2x.png (80x80)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 80x80 -colorspace sRGB "$ICON_DIR/AppIcon-40@2x.png"

echo "生成 AppIcon-40@3x.png (120x120)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 120x120 -colorspace sRGB "$ICON_DIR/AppIcon-40@3x.png"

echo "生成 AppIcon-60@2x.png (120x120)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 120x120 -colorspace sRGB "$ICON_DIR/AppIcon-60@2x.png"

echo "生成 AppIcon-60@3x.png (180x180)..."
$CONVERT_CMD "$ICON_DIR/AppIcon-1024.png" -resize 180x180 -colorspace sRGB "$ICON_DIR/AppIcon-60@3x.png"

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