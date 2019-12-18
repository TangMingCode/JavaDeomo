#!/bin/sh

/Users/zhengguihua/Desktop/SignTimeCMokey/setbundleid.sh /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey/TargetApp/*.ipa &&

/Users/zhengguihua/Library/Developer/Xcode/DerivedData/SignTimeCMokey-*/Build/Products/Debug-iphoneos/createIPA.command &&

raw_dir="/Users/zhengguihua/Library/Developer/Xcode/DerivedData/SignTimeCMokey-*/Build/Products/Debug-iphoneos/Target.ipa" #可修改绝对路径；
target_dir="/Users/zhengguihua/Desktop/SignTimeCMokey/target/Target.ipa"  #创建新的文件目录；

#生成的ipa移动到其他目录  先删除再移动
rm -rf $target_dir &&
mv $raw_dir $target_dir &&

#清空其他无用临时生成的文件夹
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey/tmp &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/TempPayload &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey/TargetApp/*.app &&
rm -rf $raw_dir
