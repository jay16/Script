## 脚本列表

### 定时提交代码

#### 脚本目的

避免由于人为的疏忽，下班时未提交代码，而无法应急由于项目服务不稳定（代码质量不过关）不能马上调试代码定位问题、解决问题、部署修正后的代码。

#### 脚本逻辑

- crontab 内加载用户环境变量

- 监控项目的入口（默认配置档优先）
    - 手工维护项目路径的配置档(projects.conf)
    - 遍历公司设备默认的项目文件夹(~/Work)

- 对监控项目（完整的绝对路径）的监测

    文件类型为文件夹，且存在 `.git/` 配置档文件夹，否则提示错误信息，跳过，不作任何操作

- 进入项目文件夹，执行 git 提交操作


#### 基本用法

```
$ git clone https://github.com/jay16/Script
$ cd Script/crontab_jobs

# debug mode list projects git status
$ bash jobs/projects_git_daemon.sh debug

# add jobs into crontab
$ crontab crontab.conf
$ crontab -l
```

