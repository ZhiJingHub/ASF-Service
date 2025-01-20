#!/bin/bash

# 当前脚本版本
SCRIPT_VERSION="v1.1.0"

# Service file URL
SERVICE_URL="https://raw.githubusercontent.com/ZhiJingHub/ASF-Service/master/asf.service"

# 更新脚本的 URL
UPDATE_URL="https://raw.githubusercontent.com/ZhiJingHub/ASF-Service/master/asf.sh"

# 脚本路径（可配置）
SCRIPT_PATH="/root/asf.sh"

# Function to check if the script is run as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "\033[31m[错误] 请以 root 用户身份运行此脚本。\033[0m"
        exit 1
    fi
}

# Function to download file with progress
download_file() {
    local url=$1
    local output=$2
    echo -e "\n\033[34m[信息] 正在从 $url 下载文件到 $output ...\033[0m"

    # 记录开始时间
    start_time=$(date +%s)

    # 使用 wget 下载文件，并显示进度条
    wget --progress=bar:force:noscroll -O "$output" "$url" && echo -e "\033[32m[成功] 文件已成功下载。\033[0m" || echo -e "\033[31m[失败] 下载文件失败。\033[0m"

    # 记录结束时间
    end_time=$(date +%s)

    # 计算下载时间
    download_time=$((end_time - start_time))
    echo -e "\033[32m[信息] 实际下载时间为 ${download_time} 秒。\033[0m\n"
}

# Function to download service file
download_service() {
    # 下载 service 文件到指定目录
    download_file "$SERVICE_URL" "/usr/lib/systemd/system/asf.service"
}

# Function to enable service
enable_service() {
    echo -e "\n\033[34m[信息] 正在启用 asf 服务...\033[0m"
    systemctl enable asf && echo -e "\033[32m[成功] 服务已成功启用。\033[0m" || echo -e "\033[31m[失败] 启用服务失败。\033[0m"
}

# Function to stop service
stop_service() {
    echo -e "\n\033[34m[信息] 正在停止 asf 服务...\033[0m"
    systemctl stop asf && echo -e "\033[32m[成功] 服务已成功停止。\033[0m" || echo -e "\033[31m[失败] 停止服务失败。\033[0m"
}

# Function to restart service
restart_service() {
    echo -e "\n\033[34m[信息] 正在重启 asf 服务...\033[0m"
    systemctl restart asf && echo -e "\033[32m[成功] 服务已成功重启。\033[0m" || echo -e "\033[31m[失败] 重启服务失败。\033[0m"
}

# Function to check service status
check_service_status() {
    echo -e "\n\033[34m[信息] 正在检查服务状态...\033[0m"
    systemctl status asf
}

# Function to update the script
update_script() {
    echo -e "\n\033[34m[信息] 正在从 $UPDATE_URL 下载更新的脚本...\033[0m"
    # 下载新的脚本文件
    download_file "$UPDATE_URL" "$SCRIPT_PATH"

    echo -e "\033[32m[成功] 脚本已成功更新。\033[0m"
    chmod +x "$SCRIPT_PATH"
    echo -e "\033[32m[信息] 正在重新启动脚本...\033[0m\n"
    # 重新执行下载的新脚本
    exec "$SCRIPT_PATH"
}

# Main menu function
main_menu() {
    check_root  # 在主菜单开始时检查一次 root 权限

    while true; do
        # 清屏
        clear
        # 输出主菜单
        echo -e "\033[1;36m========================================\033[0m"
        echo -e "\033[1;33m            ASF 管理脚本              \033[0m"
        echo -e "\033[1;33m              版本 $SCRIPT_VERSION               \033[0m"
        echo -e "\033[1;36m========================================\033[0m"
        echo -e "\033[1;35m请选择一个功能：\033[0m"
        echo -e "\033[1;34m 1. 下载并安装 service 文件\033[0m"
        echo -e "\033[1;34m 2. 启动 service\033[0m"
        echo -e "\033[1;34m 3. 停止 service\033[0m"
        echo -e "\033[1;34m 4. 重启 service\033[0m"
        echo -e "\033[1;34m 5. 查看 service 状态\033[0m"
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
                enable_service
                ;;
            3)
                stop_service
                ;;
            4)
                restart_service
                ;;
            5)
                check_service_status
                ;;
            6)
                update_script
                ;;
            0)
                echo -e "\033[1;32m[信息] 退出脚本。\033[0m"
                exit 0
                ;;
            *)
                echo -e "\033[31m[错误] 无效选择，请输入0到6之间的数字。\033[0m\n"
                ;;
        esac

        # 提示用户按任意键返回主菜单
        echo -e "\033[1;33m[信息] 按任意键返回主菜单...\033[0m"
        read -n 1
    done
}

# 运行主菜单
main_menu
