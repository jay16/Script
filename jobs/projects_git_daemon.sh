#!/usr/bin/env bash
#
# 脚本目的：
#
#     避免由于人为的疏忽，下班时未提交代码，而无法应急由于项目服务不稳定（代码质量不过关）不能马上
#     调试代码定位问题、解决问题、部署修正后的代码。
#
# 脚本逻辑：
#
# 0. crontab 内加载用户环境变量
#
# 1. 监控项目的入口（默认配置档优先）
#     1.1 手工维护项目路径的配置档(projects.conf)
#     1.2 遍历公司设备默认的项目文件夹(~/Work)
#
# 2. 对监控项目（完整的绝对路径）的监测
#
#     文件类型为文件夹，且存在 `.git/` 配置档文件夹，否则提示错误信息，跳过，不作任何操作
#
# 3. 进入项目文件夹，执行 git 提交操作
#

shell_used="${SHELL##*/}"
echo "## shell used: ${shell_used}"
[[ -f ~/.${shell_used}rc ]] && source ~/.${shell_used}rc &> /dev/null
[[ -f ~/.${shell_used}_profile ]] && source ~/.${shell_used}_profile &> /dev/null

function_auto_git_commit() {
    local project_path="$1"

    echo -e "\n## project name: ${project_path##*/}\n"
    if [[ -d "${project_path}" && -d "${project_path}/.git" ]];
    then
        cd "${project_path}"

        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        current_branch=$(git rev-parse --abbrev-ref HEAD)
        if [[ -n $(git status -s) ]];
        then
            commit_messasge="auto commit by crontab job ${timestamp}"

            git add .
            git commit -a -m "${commit_messasge}"
            git push origin "${current_branch}"

            echo "${project_path}@${current_branch} ${commit_messasge}"
        else
            echo "${project_path}@${current_branch} not modified ${timestamp}"
        fi
    else
        error_message=$([[ -d "${project_path}" ]] && echo 'no git configuration' || echo 'not exit')
        echo "ERROR: project path ${error_message} - ${project_path}"
    fi
}

conf_file="projects.conf"
if [[ -f "${conf_file}" ]];
then
    #
    # ls ~/Work | xargs -I pathname echo "/Users/$(whoami)/Work/pathname" > .projects.conf
    #
    cat "${conf_file}" | while read project_path; do
        function_auto_git_commit "${project_path}"
    done
else
    project_folder="/Users/$(whoami)/Work"
    for project_name in $(ls ${project_folder});
    do
        function_auto_git_commit "${project_folder}/${project_name}"
    done
fi


