#!/bin/bash

# 指定要处理的文件夹路径
BASE_PATH="/storage/emulated/0/icon"
# 指定重命名后文件要移动到的目标文件夹路径
TARGET_PATH="/storage/emulated/0/icons"
# 黑名单文件路径
BLACKLIST_FILE="/storage/emulated/0/icon黑名单.yaml"

# 确保目标文件夹存在
mkdir -p "$TARGET_PATH"

# 检查BASE_PATH是否存在
if [ ! -d "$BASE_PATH" ]; then
  echo "错误：目录 $BASE_PATH 不存在，脚本停止运行。"
  exit 1
fi

# 初始化计数器
RENAME_COUNT=0
SKIP_COUNT=0

# 加载黑名单
declare -a BLACKLIST
if [ -f "$BLACKLIST_FILE" ]; then
  echo "检测到黑名单文件，加载排除列表..."
  while IFS= read -r line || [[ -n "$line" ]]; do
    # 跳过空行和注释行
    if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
      BLACKLIST+=("$line")
      echo "添加黑名单: $line"
    fi
  done < "$BLACKLIST_FILE"
  echo "已加载 ${#BLACKLIST[@]} 个黑名单项"
fi

# 遍历每个子文件夹
for DIR in "$BASE_PATH"/*/; do
  DIR_NAME=$(basename "$DIR")
  
  # 检查是否在黑名单中
  skip=0
  for item in "${BLACKLIST[@]}"; do
    if [ "$DIR_NAME" == "$item" ]; then
      echo "跳过黑名单目录: $DIR_NAME"
      skip=1
      SKIP_COUNT=$((SKIP_COUNT + 1))
      break
    fi
  done
  
  [ $skip -eq 1 ] && continue

  # 检查0.png和1.png是否存在
  if [ -e "$DIR/0.png" ] && [ -e "$DIR/1.png" ]; then
    mv "$DIR/0.png" "$DIR/${DIR_NAME}_bg.png"
    mv "$DIR/1.png" "$DIR/${DIR_NAME}_fg.png"

    # 将重命名后的文件移动到目标文件夹
    mv "$DIR/${DIR_NAME}_bg.png" "$TARGET_PATH/"
    mv "$DIR/${DIR_NAME}_fg.png" "$TARGET_PATH/"

    # 增加计数器
    RENAME_COUNT=$((RENAME_COUNT + 1))
       
    # 可选：移动后删除原文件夹（如果里面没有其他文件）
    rmdir "$DIR" 2>/dev/null  # 忽略非空文件夹的错误
  else
    echo "在 $DIR 找不到0.png和1.png"
  fi
done

echo "操作完成"
echo "成功重命名: $RENAME_COUNT 个目录"
echo "跳过黑名单: $SKIP_COUNT 个目录"