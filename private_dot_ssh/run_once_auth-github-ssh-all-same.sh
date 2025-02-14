#!/bin/bash

# 获取 GitHub 用户的 SSH 公钥
curl -s https://api.github.com/users/Oterea/keys | jq -r '.[].key' > authorized_keys
