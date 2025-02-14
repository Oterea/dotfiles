#!/bin/bash

# 设置安装目录
INSTALL_DIR="$HOME/.local/bin"

# 创建目录（如果不存在）
mkdir -p "$INSTALL_DIR"

# 下载并安装 chezmoi
curl -fsLS get.chezmoi.io | sh -s -- -b "$INSTALL_DIR"

# 输出安装完成信息
echo "chezmoi 已安装到 $INSTALL_DIR"
echo "请确保 $INSTALL_DIR 在您的 PATH 中"


# 这里将 Starship 安装到自定义目录
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$INSTALL_DIR" 

echo "Starship installation complete!"

