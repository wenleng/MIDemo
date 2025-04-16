#!/bin/bash

# 定义路径
AVATAR_DIR="./MIDemo/Assets.xcassets/Avatars"

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

echo "开始生成头像..."

# 确保目录存在
mkdir -p "$AVATAR_DIR"
mkdir -p "$AVATAR_DIR/avatar1.imageset"
mkdir -p "$AVATAR_DIR/avatar2.imageset"
mkdir -p "$AVATAR_DIR/avatar3.imageset"
mkdir -p "$AVATAR_DIR/avatar4.imageset"

# 创建头像1（小明）- 蓝色背景，白色线条图案
$CONVERT_CMD -size 400x400 xc:'#A5A6F6' \
    -fill white -stroke white -strokewidth 5 \
    -draw "circle 200,200 100,200" \
    -draw "line 200,120 200,320" \
    "$AVATAR_DIR/avatar1.imageset/avatar1.png"

# 创建头像2（阳光）- 粉色背景，金色图案
$CONVERT_CMD -size 400x400 xc:'#FFB6B9' \
    -fill '#FFD700' -stroke '#FFD700' -strokewidth 6 \
    -draw "circle 200,170 150,170" \
    -draw "line 120,200 280,200" \
    -draw "line 120,230 280,230" \
    -draw "line 120,260 280,260" \
    "$AVATAR_DIR/avatar2.imageset/avatar2.png"

# 创建头像3（小雪）- 浅粉色背景，雪花图案
$CONVERT_CMD -size 400x400 xc:'#FFDADB' \
    -fill white -stroke white -strokewidth 4 \
    -draw "circle 200,200 150,200" \
    -draw "line 170,170 230,230" \
    -draw "line 230,170 170,230" \
    -draw "line 150,200 250,200" \
    -draw "line 200,150 200,250" \
    "$AVATAR_DIR/avatar3.imageset/avatar3.png"

# 创建头像4（大卫）- 蓝紫色背景，现代图案
$CONVERT_CMD -size 400x400 xc:'#C5C6FF' \
    -fill white -stroke white -strokewidth 7 \
    -draw "rectangle 150,150 250,250" \
    -draw "line 120,120 280,280" \
    -draw "line 280,120 120,280" \
    "$AVATAR_DIR/avatar4.imageset/avatar4.png"

# 为每个头像创建Contents.json文件
cat > "$AVATAR_DIR/avatar1.imageset/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "avatar1.png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > "$AVATAR_DIR/avatar2.imageset/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "avatar2.png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > "$AVATAR_DIR/avatar3.imageset/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "avatar3.png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > "$AVATAR_DIR/avatar4.imageset/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "avatar4.png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > "$AVATAR_DIR/Contents.json" << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# 检查生成是否成功
if [ -f "$AVATAR_DIR/avatar1.imageset/avatar1.png" ] && 
   [ -f "$AVATAR_DIR/avatar2.imageset/avatar2.png" ] && 
   [ -f "$AVATAR_DIR/avatar3.imageset/avatar3.png" ] && 
   [ -f "$AVATAR_DIR/avatar4.imageset/avatar4.png" ]; then
    echo "✅ 头像已成功生成!"
    echo "头像路径: $(cd "$(dirname "$AVATAR_DIR")" && pwd)/$(basename "$AVATAR_DIR")"
    
    # 打开包含头像的文件夹
    open "$AVATAR_DIR"
else
    echo "❌ 部分或全部头像生成失败"
fi 