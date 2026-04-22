# Git 版本控制和 GitHub 协作

## References

- [Git 官方文档](https://git-scm.com/docs)
- [Pro Git 中文](https://git-scm.com/book/zh/v2)
- [GitHub 官方文档](https://docs.github.com/)
- [菜鸟教程 Git 教程](https://www.runoob.com/git/git-tutorial.html)

## Git 配置和 SSH 密钥

安装 Git

```sh
# Windows
winget install --id Git.Git -e --source winget
# macOS
brew install git
# Linux (Debian/Ubuntu)
sudo apt-get install git
# Linux (Fedora/RHEL)
sudo dnf install git
```

配置 Git 用户信息：

```sh
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

生成 SSH 密钥并输出公钥：

```sh
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub
```

粘贴公钥到 GitHub 账户设置中的 SSH 和 GPG 密钥部分，建议命名为“主机名+系统名+用户名” 如 “T14s-Fedora-brofea”