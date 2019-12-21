#!/bin/sh

basePath=$(cd "$(dirname "$0")";pwd)

$basePath/setbundleid.sh  $basePath/SignTimeCMokey/TargetApp/*.ipa &&

userPath=${HOME}
$userPath/Library/Developer/Xcode/DerivedData/SignTimeCMokey-*/Build/Products/Debug-iphoneos/createIPA.command &&

raw_dir="$userPath/Library/Developer/Xcode/DerivedData/SignTimeCMokey-*/Build/Products/Debug-iphoneos/Target.ipa" #可修改绝对路径；
target_dir="$basePath/target/Target.ipa"  #创建新的文件目录；

#生成的ipa移动到其他目录  先删除再移动
rm -rf $target_dir &&
mv $raw_dir $target_dir &&

#清空其他无用临时生成的文件夹
rm -rf $basePath/SignTimeCMokey/tmp &&
rm -rf $basePath/TempPayload &&
rm -rf $basePath/SignTimeCMokey/TargetApp/*.app &&
rm -rf $raw_dir
