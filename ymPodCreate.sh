#!/bin/bash

clear
echo "------------------------------------------------------------"
echo "----------------------开始创建pod源---------------------------"
echo "-------------------------------------------------------------"
user_name='PodCreateExample'
# echo "输入文件目录"
# read file_directory
file_directory='/Users/ym/Documents/CD1'
echo "-----》进入目录${file_directory}"

cd  $file_directory
# 路径错误
if [ $? -eq 1 ]; then echo -e "没有此目录"; exit 1;fi


echo "输入文件名"
read file_name
echo "即将创建Pod模板文件${file_name}"

pod repo add ${file_name} https://github.com/${user_name}/${file_name}.git

#删除原来存在的文件夹
rm -rf  $file_name
if [ $? -eq 1 ]; then echo -e "删除失败"; exit 1;fi

#-----------
#创建本地文件	|
#-----------
echo "-----》执行"
pod lib create $file_name
# if [ $? -eq 1 ]; then
#         echo -e "执行失败"
#         exit 1
# fi
echo "-----》执行完成"

echo "-----》需要修改相关信息 github 地址"

#-------------
#修改相关信息
#-------------
cd $file_name
echo "-----》修改字符串"

echo "-----》修改目标名 为 GITHUB_USERNAME ${user_name}"

# 修改字符串 将 <GITHUB_USERNAME> 替换为 项目名
sed -i '' "s/<GITHUB_USERNAME>/${user_name}/g"  ${file_name}.podspec
if [ $? -eq 1 ]; then echo -e "修改字符串失败"; exit 1;fi

sed -i '' "s/GITHUB_USERNAME/${user_name}/g"  ${file_name}.podspec
if [ $? -eq 1 ]; then echo -e "修改字符串失败"; exit 1;fi

sed -i '' "s/A short description of /ym/g"  ${file_name}.podspec
if [ $? -eq 1 ]; then echo -e "修改字符串失败"; exit 1;fi

echo "-----》修改字符串完毕"
 
echo "-----》开始本地验证"
pod lib lint 
if [ $? -eq 1 ]; then echo -e "验证失败"; exit 1;fi

echo "-----》本地验证完毕"

#-------------
#推送到远程
#-------------
echo "-----》准备推送到远端"
echo "-----》git init"
git init
echo "-----》git add ."
git add .
echo "-----》git commit"
git commit -m "first commit"

echo "-----》git remote add origin https://github.com/${user_name}/${file_name}.git"
git remote add origin https://github.com/${user_name}/${file_name}.git


if [ $? -eq 1 ]; then echo -e "远程添加失败"; exit 1; fi

echo "-----》git push -u origin master --force"
git push -u origin master --force
if [ $? -eq 1 ]; then echo -e "推送失败"; exit 1;fi

echo "-----》git tag -a 0.1.0 -m '0.1.0' "
git tag -a 0.1.0 -m '0.1.0' 

echo "-----》git push --tags --force"
git push --tags --force

echo "-----》远端验证"
pod spec lint
if [ $? -eq 1 ]; then echo -e "远端验证失败"; exit 1;fi
echo "-----》远端验证完成"


