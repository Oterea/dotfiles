# 新服务器 Setup

从零到可用，四条命令。适用于国内云服务器（腾讯云等），VNC 或密码首次登录。

## 快速版

```sh
eval "$(curl https://get.x-cmd.com)"
x boot clear
x env use chezmoi starship zoxide fzf
chezmoi init --apply https://gh-proxy.com/https://github.com/Oterea/dotfiles.git
exec bash
```

跑完从本机 `ssh root@IP` 就能直连，VNC 不用再开。

---

## 分步说明

### 1. 装 x-cmd

```sh
eval "$(curl https://get.x-cmd.com)"
```

下载源是阿里云 OSS 河源节点，**国内直连，不需要代理**。装到 `~/.x-cmd.root`，全程无 root。

### 2. 清掉它写进 rc 文件的启动代码

```sh
x boot clear
```

x-cmd 安装时会往 `.bashrc`、`.zshrc`、`.bash_profile` 等多个文件里塞一行：

```sh
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
```

这一行不需要 —— 本仓库的 `dot_bashrc` 已经有更完整的加载逻辑（额外负责设置 PATH 和报告状态）。留着只会重复 source。

`x boot clear` 的实现是按字面串匹配安装器写的标记注释、命中就整行删除。本仓库的 `dot_bashrc` 刻意避开了那串字，所以两步谁先谁后都安全 —— 放在这里只是因为紧接着安装它更顺。

### 3. 装工具

```sh
x env use chezmoi starship zoxide fzf
```

走 x-cmd 自己的包源，同样不碰 GitHub。验证：

```sh
x env ls
```

`x env use` 是持久安装（跨会话），对应的临时版本是 `x env try`，关掉终端就失效。

### 4. 拉配置

```sh
chezmoi init --apply https://gh-proxy.com/https://github.com/Oterea/dotfiles.git
```

一步完成三件事：

- clone 仓库到 `~/.local/share/chezmoi`
- 从 `.chezmoi.toml.tmpl` 生成 `~/.config/chezmoi/chezmoi.toml`
- apply 全部配置，其中包括 **`~/.ssh/authorized_keys`** —— 这是之后能从本机直连的关键

自己的代理跑起来之后可以去掉 `https://gh-proxy.com/` 前缀，直接用 GitHub 地址。

### 5. 重新加载

```sh
exec bash
```

应该看到：

```
  ✓ x-cmd
  ✓ starship
  ✓ zoxide
```

红色 ✗ 表示对应工具没装上，回到第 3 步查。

### 6. 从本机直连

```sh
ssh root@服务器IP
```

VNC 到此为止。

---

## 可选：服务器需要 push 到 GitHub

只拉配置不推送的话跳过 —— 公开仓库 HTTPS 只读不需要任何凭据。

需要推送时，给这台服务器生成**它自己的**密钥：

```sh
ssh-keygen -t ed25519 -N "" -C "服务器名"
cat ~/.ssh/id_ed25519.pub
```

把输出加到 GitHub → Settings → SSH and GPG keys。

一机一钥：某台服务器被入侵，只需在 GitHub 删掉那一把，不影响其他机器。**不要把个人主密钥复制到服务器上。**

---

## 日常维护

```sh
chezmoi update      # 拉最新配置并 apply
chezmoi diff        # 看本机和仓库的差异
chezmoi status      # 有改动的文件（MM = 双向都有差异）
```

remote 指向的是带 gh-proxy 的地址，`chezmoi update` 会走代理。改成直连：

```sh
chezmoi cd
git remote set-url origin https://github.com/Oterea/dotfiles.git
```

### 装了新工具之后

带 `init` 步骤的安装器（`conda init`、各类 `curl | sh`）习惯往 rc 文件末尾追加内容，它们不知道 chezmoi 的存在。装完跑一次：

```sh
chezmoi diff
```

有漂移的话，决定是收进仓库（`chezmoi re-add`）还是丢弃（`chezmoi apply`）。

**注意**：`chezmoi re-add` 会跳过模板文件（`.tmpl`），且不报错。`dot_config/fish/config.fish.tmpl` 属于这种，只能手动编辑源文件。

---

## 本仓库的结构

| 源文件 | 部署到 | 备注 |
|---|---|---|
| `dot_bashrc` | `~/.bashrc` | macOS 下被忽略 |
| `dot_zshrc` | `~/.zshrc` | Linux 下被忽略 |
| `dot_vimrc` | `~/.vimrc` | |
| `dot_gitconfig` | `~/.gitconfig` | |
| `dot_config/fish/config.fish.tmpl` | `~/.config/fish/config.fish` | 模板，按 OS 分支 |
| `dot_config/starship.toml` | `~/.config/starship.toml` | |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` | Linux 下被忽略 |
| `private_dot_ssh/authorized_keys.tmpl` | `~/.ssh/authorized_keys` | macOS 下被忽略 |

平台差异由两个机制控制：

- **`.chezmoiignore`** —— 整个文件在某平台要不要存在
- **模板里的 `{{ if eq .chezmoi.os "linux" }}`** —— 同一文件内部哪几行不同

仓库里**没有任何密钥或加密内容**，可以公开。SSH 私钥存在 Bitwarden，或者每台机器自己生成。
