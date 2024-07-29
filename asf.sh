#!/bin/bash

# Service file URL
SERVICE_URL="https://raw.githubusercontent.com/ZhiJingHub/ASF-Service/master/asf.service"

# Function to check if the script is run as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "\033[31m请以root用户身份运行此脚本。\033[0m"
        exit 1
    fi
}

# Function to download service file
download_service() {
    echo -e "\033[34m正在从 $SERVICE_URL 下载 service 文件...\033[0m"
    wget -O /usr/lib/systemd/system/asf.service "$SERVICE_URL"
    if [ $? -eq 0 ]; then
        echo -e "\033[32m文件已成功下载并放置到 /usr/lib/systemd/system。\033[0m"
    else
        echo -e "\033[31m下载失败，请检查链接和网络连接。\033[0m"
    fi
}

# Function to enable service
enable_service() {
    systemctl enable asf
    if [ $? -eq 0 ]; then
        echo -e "\033[32mService 已成功启用。\033[0m"
    else
        echo -e "\033[31m启用服务失败。\033[0m"
    fi
}

# Function to stop service
stop_service() {
    systemctl stop asf
    if [ $? -eq 0 ]; then
        echo -e "\033[32mService 已成功停止。\033[0m"
    else
        echo -e "\033[31m停止服务失败。\033[0m"
    fi
}

# Function to restart service
restart_service() {
    systemctl restart asf
    if [ $? -eq 0 ]; then
        echo -e "\033[32mService 已成功重启。\033[0m"
    else
        echo -e "\033[31m重启服务失败。\033[0m"
    fi
}

# Main menu function
main_menu() {
    while true; do
        clear
        echo -e "\033[1;36m========================================\033[0m"
        echo -e "\033[1;33m            ASF 管理脚本              \033[0m"
        echo -e "\033[1;36m========================================\033[0m"
        echo -e "\033[1;35m请选择一个功能：\033[0m"
        echo -e "\033[1;34m 1. 下载并安装service文件\033[0m"
        echo -e "\033[1;34m 2. 启动service\033[0m"
        echo -e "\033[1;34m 3. 停止service\033[0m"
        echo -e "\033[1;34m 4. 重启service\033[0m"
        echo -e "\033[1;34m 5. 退出\033[0m"
        echo -e "\033[1;36m========================================\033[0m"
        read -p $'\033[1;33m请输入你的选择 (1-5): \033[0m' choice

        case $choice in
            1)
                check_root
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
                echo -e "\033[1;32m退出脚本。\033[0m"
                exit 0
                ;;
            *)
                echo -e "\033[31m无效选择，请输入1到5之间的数字。\033[0m"
                ;;
        esac
        echo -e "\033[1;33m按任意键返回主菜单...\033[0m"
        read -n 1
    done
}

# Run the main menu
main_menu
