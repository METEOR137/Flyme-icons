#!/system/bin/sh
# Flyme图标提取流程脚本
WORKDIR=/storage/emulated/0
ICONS=$WORKDIR/icons
ICONS_NIGHT=$WORKDIR/icons_night

echo "开始执行Flyme图标提取..."
sh $WORKDIR/Flyme图标提取.sh

# 检查前一个命令是否成功（即 Flyme图标提取.sh 的退出状态）
if [ $? -eq 0 ]; then
    # 检查 ICONS_NIGHT 目录是否存在
    if [ -d "$ICONS_NIGHT" ]; then
        echo "Flyme深色图标适配提取开始..."
        sh $WORKDIR/Flyme深色图标适配提取.sh
    else
        echo "icons_night目录不存在，跳过Flyme深色图标适配提取。"
    fi
fi

# 检查前一个命令是否成功（包括 Flyme深色图标适配提取.sh 的执行或跳过状态）
if [ $? -eq 0 ]; then
    # 检查 ICONS目录是否存在
    if [ -d "$ICONS" ]; then
        echo "Flyme分层图标适配名单提取开始..."
        sh $WORKDIR/Flyme分层图标适配名单提取.sh
    else
        echo "icons目录不存在，跳过Flyme分层图标适配名单提取。"
    fi
fi

echo "所有任务执行完毕。"