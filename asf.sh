#!/bin/bash

# 当前脚本版本
SCRIPT_VERSION="v1.0.0"

# Service file URL
SERVICE_URL="https://raw.githubusercontent.com/ZhiJingHub/ASF-Service/master/asf.service"

# 更新脚本的 URL
UPDATE_URL="https://raw.githubusercontent.com/ZhiJingHub/ASF-Service/master/asf.sh"

# Function to check if the script is run as root
check_root() {
    # 检查当前用户是否为root用户
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "\033[31m请以root用户身份运行此脚本。\033[0m"
        exit 1
    fi
}

# Function to download file with progress
download_file() {
    local url=$1
    local output=$2
    echo -e "\033[34m正在从 $url 下载文件到 $output ...\033[0m"

    # 记录开始时间
    start_time=$(date +%s)

    # 使用wget下载文件，并显示进度条
    wget --progress=bar:force:noscroll -O "$output" "$url" 2>&1 | \
    awk 'BEGIN { FS=" " } { if ($7 ~ /[0-9]+%/) { print $7, $8, $9 } }'

    # 记录结束时间
    end_time=$(date +%s)

    # 计算下载时间
    download_time=$((end_time - start_time))
    echo -e "\033[32m文件已成功下载，实际下载时间为 ${download_time} 秒。\033[0m"
}

# Function to download service file
download_service() {
    check_root
    # 下载service文件到指定目录
    download_file "$SERVICE_URL" "/usr/lib/systemd/system/asf.service"
}

# Function to enable service
enable_service() {
    # 启用asf服务
    systemctl enable asf
    if [ $? -eq 0 ]; then
        echo -e "\033[32mService 已成功启用。\033[0m"
    else
        echo -e "\033[31m启用服务失败。\033[0m"
    fi
}

# Function to stop service
stop_service() {
    # 停止asf服务
    systemctl stop asf
    if [ $? -eq 0 ]; then
        echo -e "\033[32mService 已成功停止。\033[0m"
    else
        echo -e "\033[31m停止服务失败。\033[0m"
    fi
}

# Function to restart service
restart_service() {
    # 重启asf服务
    systemctl restart asf
    if [ $? -eq 0 ]; then
        echo -e "\033[32mService 已成功重启。\033[0m"
    else
        echo -e "\033[31m重启服务失败。\033[0m"
    fi
}

# Function to check service status
check_service_status() {
    # 检查asf服务的状态
    echo -e "\033[34m正在检查服务状态...\033[0m"
    systemctl status asf
}

# Function to update the script
update_script() {
    check_root
    echo -e "\033[34m正在从 $UPDATE_URL 下载更新的脚本...\033[0m"
    # 下载新的脚本文件
    download_file "$UPDATE_URL" "/root/asf.sh"

    echo -e "\033[32m脚本已成功更新。\033[0m"
    chmod +x /root/asf.sh
    echo -e "\033[32m正在重新启动脚本...\033[0m"
    # 重新执行下载的新脚本
    exec /root/asf.sh
}

# Main menu function
main_menu() {
    while true; do
        # 清屏
        clear
        # 输出主菜单
        echo -e "\033[1;36m========================================\033[0m"
        echo -e "\033[1;33m            ASF 管理脚本              \033[0m"
        echo -e "\033[1;33m              版本 $SCRIPT_VERSION               \033[0m"
        echo -e "\033[1;36m========================================\033[0m"
        echo -e "\033[1;35m请选择一个功能：\033[0m"
        echo -e "\033[1;34m 1. 下载并安装service文件\033[0m"
        echo -e "\033[1;34m 2. 启动service\033[0m"
        echo -e "\033[1;34m 3. 停止service\033[0m"
        echo -e "\033[1;34m 4. 重启service\033[0m"
        echo -e "\033[1;34m 5. 查看service状态\033[0m"
        echo -e "\033[1;34m 6. 更新脚本\033[0m"
        echo -e "\033[1;34m 0. 退出\033[0m"
        echo -e "\033[1;36m========================================\033[0m"
        
        # 读取用户输入
        read -p $'\033[1;33m请输入你的选择 (0-6): \033[0m' choice

        # 根据用户选择执行相应功能
        case $choice in
            1)
                download_service
                ;;
            2)
                check_root
                enable_service
                ;;
            3)
                check_root
                stop_service
                ;;
            4)
                check_root
                restart_service
                ;;
            5)
                check_root
                check_service_status
                ;;
            6)
                update_script
                ;;
            0)
                echo -e "\033[1;32m退出脚本。\033[0m"
                exit 0
                ;;
            *)
                echo -e "\033[31m无效选择，请输入0到6之间的数字。\033[0m"
                ;;
        esac

        # 提示用户按任意键返回主菜单
        echo -e "\033[1;33m按任意键返回主菜单...\033[0m"
        read -n 1
    done
}

# 运行主菜单
main_menu
