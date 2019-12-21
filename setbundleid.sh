#!/bin/sh

# basePath=$(dirname $0)
basePath=$(cd "$(dirname "$0")";pwd)
echo "基础目录地址 basePath : $basePath"

# ipa路径
ipaFilePath=${1}
if [ ! -f "$ipaFilePath" ]; then
    echo "未找到ipa包 $ipaFilePath"
    exit 2
fi

# 当前ipa解压路径
temIpaDirName="TempPayload"
temIpaDirPath="${basePath}/${temIpaDirName}"
echo "当前ipa解压路径 temIpaDirPath : $temIpaDirPath"

# 删除临时解包目录
if [ -d "$temIpaDirPath" ]; then
    echo "删除临时解包目录 rm ${temIpaDirPath}"
    rm -rf "${temIpaDirPath}"
fi

# 解包IPA
if [[ -f "$ipaFilePath" ]]; then
    echo "unzip $ipaFilePath begin ..."
    unzip "$ipaFilePath" -d "$temIpaDirPath"
fi

# 定位到 *.app 目录及 info.plist
appDir="$temIpaDirPath/Payload/`ls "$temIpaDirPath/"Payload`"
lcmInfoPlist="${appDir}/Info.plist"
echo "info.plist文件路径 lcmInfoPlist : $lcmInfoPlist"

userPath=${HOME}
targetInfoPlist="$userPath/Library/Developer/Xcode/DerivedData/SignTimeCMokey-*/Build/Products/Debug-iphoneos/SignTimeCMokey.app/Info.plist"

# 获取app的名称、版本号、build号
appName=`/usr/libexec/PlistBuddy -c "Print :CFBundleName" $lcmInfoPlist`
echo "appName : $appName"
/usr/libexec/PlistBuddy -c "Set CFBundleName $appName" $targetInfoPlist

appVersion=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" $lcmInfoPlist`
echo "appVersion : $appVersion"
/usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $appVersion" $targetInfoPlist

appBuild=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" $lcmInfoPlist`
echo "appBuild : $appBuild"
/usr/libexec/PlistBuddy -c "Set CFBundleVersion $appBuild" $targetInfoPlist

appBundleId=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" $lcmInfoPlist`
echo "appBundleId : $appBundleId"
/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier $appBundleId" $targetInfoPlist


#mv $lcmInfoPlist $targetInfoPlist &&

echo "恭喜操作成功！！！"
