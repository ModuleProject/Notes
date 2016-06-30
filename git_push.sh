#!/bin/bash

echo "输入提交信息"
read push_info

echo "-----》git add ."
git add .
if [ $? -eq 1 ]; then echo -e "add 失败"; exit 1; fi

echo "-----》git commit"
git commit -m ${push_info}
if [ $? -eq 1 ]; then echo -e "commit 失败"; exit 1; fi

git pull
if [ $? -eq 1 ]; then echo -e "pull 失败"; exit 1; fi

git push	
if [ $? -eq 1 ]; then echo -e "push 失败"; exit 1; fi
