#!/bin/bash

# 源目录和目标文件路径
FLYME="Flyme图标提取"
src_dir="/storage/emulated/0/$FLYME/icon"
output_file="/storage/emulated/0/$FLYME/icon.txt"

# 清空目标文件（覆盖写入）
> "$output_file"

# 遍历源目录下所有 _bg.png 文件
find "$src_dir" -maxdepth 1 -type f -name "*_bg.png" | while read -r file; do
    # 提取纯文件名（不含路径）
    filename=$(basename "$file")
    
    # 移除后缀 _bg.png 得到包名
    pkg_name="${filename%_bg.png}"
    
    # 将包名写入目标文件
    echo "$pkg_name" >> "$output_file"
done

echo "包名提取完成！结果已保存至 $output_file"