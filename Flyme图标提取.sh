#!/system/bin/sh

# 定义源目录和文件名
SOURCE_DIR="/storage/emulated/0"
TARGET_1="icons"
TARGET_2="icons_night"
FLYME="Flyme图标提取"

# 解压函数：创建指定目录并解压
unzip_to_folder() {
    local file_name="$1"
    local src_file="${SOURCE_DIR}/${file_name}"
    
    # 动态设置目标目录名
    local target_subdir
    case "$file_name" in
        "$TARGET_1") target_subdir="icon" ;;
        "$TARGET_2") target_subdir="icons_night" ;;
        *) 
            echo "错误：不支持的文件名 $file_name"
            return 1 
            ;;
    esac
    
    local target_dir="${SOURCE_DIR}/${FLYME}/${target_subdir}"
    
    # 检查源文件是否存在
    if [ ! -f "$src_file" ]; then
        echo "错误：源文件 $src_file 不存在"
        return 2
    fi
    
    # 创建目标目录（完整路径）
    mkdir -p "$target_dir" 2>/dev/null
    if [ ! -d "$target_dir" ]; then
        echo "错误：无法创建目录 $target_dir"
        return 3
    fi
    
    # 执行解压操作
    unzip -o "$src_file" -d "$target_dir" >/dev/null 2>&1
    
    # 检查解压结果
    if [ $? -eq 0 ]; then
        echo "解压成功：$src_file → $target_dir"
    else
        echo "错误：$file_name 解压失败（请确认是否为ZIP格式）"
        rm -rf "$target_dir"  # 清理失败目录
        return 4
    fi
}

# 主执行流程
mkdir -p "${SOURCE_DIR}/${FLYME}"  # 确保父目录存在
unzip_to_folder "$TARGET_1"
unzip_to_folder "$TARGET_2"

echo "操作完成"
exit 0