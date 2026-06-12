# MySQL

## 环境配置

默认在 `localhost:3306` 上运行

### macOS

安装

```sh
brew install mysql
```

用 `brew services` 命令作为本机服务启动和停止

```sh
brew services start mysql
brew services stop mysql
brew services list          # 查看服务状态
```

### macOS & Linux 通用

用 `mysql.server` 命令启动、停止和重启服务

```sh
mysql.server start
mysql.server stop
mysql.server restart
```

可以执行 `mysql` 检查 MySQL 是否正在运行

## 登录

默认用户名为 `root`，没有密码

```sh
mysql -u root
mysql>           # 进入 MySQL 命令行
```

设置 root 用户密码

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password-114514';
FLUSH PRIVILEGES;
```

使用密码登录

```sh
mysql -u root -p password-114514
```