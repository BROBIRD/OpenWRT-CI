#!/bin/bash

# 脚本功能: 使用 GitHub API 递归下载仓库中的单个文件夹
# 版本: 2.0
# 更新: 允许用户通过命令行参数指定目标目录
# 依赖: curl, jq

set -e # 如果任何命令失败，则立即退出

# --- 配置 ---
# 如果你频繁使用此脚本，建议生成一个GitHub Personal Access Token (PAT)
# 并填在这里，以避免API速率限制。Token只需要 'public_repo' 权限即可。
# 更多信息: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
GITHUB_TOKEN=""

# --- 函数定义 ---

# 显示用法
usage() {
    echo "Usage: $0 <GitHub Folder URL> [Destination Directory]"
    echo
    echo "Arguments:"
    echo "  <GitHub Folder URL>      The full URL of the GitHub folder to download."
    echo "  [Destination Directory]  (Optional) The local directory to download files into."
    echo "                           If not provided, a directory with the same name as the"
    echo "                           GitHub folder will be created in the current location."
    echo
    echo "Example 1 (auto-creates 'react' dir):"
    echo "  $0 https://github.com/facebook/react/tree/main/packages/react"
    echo
    echo "Example 2 (downloads to 'my-react-code' dir):"
    echo "  $0 https://github.com/facebook/react/tree/main/packages/react my-react-code"
    exit 1
}

# 主要的下载函数，递归调用
download_dir() {
    local api_url=$1
    local local_path=$2

    # 设置 curl 的 headers
    local headers=(-H "Accept: application/vnd.github.v3+json")
    if [ -n "$GITHUB_TOKEN" ]; then
        headers+=(-H "Authorization: token $GITHUB_TOKEN")
    fi

    # 请求 API 并处理响应
    # -s: 静默模式, -L: 跟随重定向
    local response
    response=$(curl -s -L "${headers[@]}" "$api_url")

    # 检查 API 是否返回了错误信息
    if echo "$response" | jq -e 'if type=="object" and .message then true else false end' > /dev/null; then
        echo "Error fetching from GitHub API:"
        echo "$response" | jq -r '.message'
        exit 1
    fi

    # 检查返回的是否是有效的JSON数组
    if ! echo "$response" | jq -e 'if type=="array" then true else false end' > /dev/null; then
        echo "Error: Invalid API response. Expected a JSON array."
        echo "Response was: $response"
        exit 1
    fi

    # 创建本地目录
    mkdir -p "$local_path"
    echo "Created directory: $local_path"

    # 使用 jq 解析 JSON 并循环处理每个项目
    # -r: raw output, 去掉字符串的引号
    echo "$response" | jq -r '.[] | @base64' | while read -r item_base64; do
        local item_json
        item_json=$(echo "$item_base64" | base64 --decode)

        local type name path download_url next_api_url
        type=$(echo "$item_json" | jq -r '.type')
        name=$(echo "$item_json" | jq -r '.name')
        path=$(echo "$item_json" | jq -r '.path')
        download_url=$(echo "$item_json" | jq -r '.download_url')
        next_api_url=$(echo "$item_json" | jq -r '.url') # for dirs

        local full_local_path="$local_path/$name"

        if [ "$type" == "file" ]; then
            echo "  Downloading file: $full_local_path"
            curl -s -L -o "$full_local_path" "$download_url"
        elif [ "$type" == "dir" ]; then
            # 递归调用下载子目录
            download_dir "$next_api_url" "$full_local_path"
        fi
    done
}

# --- 脚本主逻辑 ---

# 检查参数
if [ -z "$1" ]; then
    usage
fi

# 1. 解析输入的 GitHub URL
G_URL=$1
if ! [[ "$G_URL" =~ ^https://github.com/([^/]+)/([^/]+)/tree/([^/]+)/(.*)$ ]]; then
    echo "Error: Invalid GitHub folder URL format."
    usage
fi

OWNER="${BASH_REMATCH[1]}"
REPO="${BASH_REMATCH[2]}"
BRANCH="${BASH_REMATCH[3]}"
FOLDER_PATH="${BASH_REMATCH[4]}"

# 移除路径末尾的斜杠
FOLDER_PATH=${FOLDER_PATH%/}

# 2. 构建初始 API URL
INITIAL_API_URL="https://api.github.com/repos/$OWNER/$REPO/contents/$FOLDER_PATH?ref=$BRANCH"

# 3. 设置本地目标文件夹名称
#   - 如果提供了第二个参数 ($2)，则使用它作为目标目录。
#   - 否则，自动根据URL中的文件夹名创建目录。
DEST_FOLDER=""
if [ -n "$2" ]; then
    DEST_FOLDER="$2"
else
    DEST_FOLDER=$(basename "$FOLDER_PATH")
    if [ -z "$DEST_FOLDER" ] || [ "$DEST_FOLDER" == "." ]; then
        DEST_FOLDER=$REPO # 如果是根目录，则使用仓库名
    fi
fi

echo "--- Download Details ---"
echo "Owner: $OWNER"
echo "Repo: $REPO"
echo "Branch: $BRANCH"
echo "Folder Path: $FOLDER_PATH"
echo "Destination: $DEST_FOLDER"
echo "------------------------"

# 4. 开始下载
download_dir "$INITIAL_API_URL" "$DEST_FOLDER"

echo
echo "✅ Download complete! Files are in '$DEST_FOLDER'"