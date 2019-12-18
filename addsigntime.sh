#!/bin/sh
#重置BundleId  BundleName  BundleVersion....
#编译项目 给ipa包注入动态库
xcodebuild -project /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey.xcodeproj &&
#生成ipa包
/Users/zhengguihua/Desktop/SignTimeCMokey/build/Release-iphoneos/createIPA.command &&

raw_dir="/Users/zhengguihua/Desktop/SignTimeCMokey/build/Release-iphoneos/Target.ipa" #可修改绝对路径；
target_dir="/Users/zhengguihua/Desktop/SignTimeCMokey/target/Target.ipa"  #创建新的文件目录；

#生成的ipa移动到其他目录  先删除再移动
rm -rf $target_dir &&
mv $raw_dir $target_dir &&
echo "移动target.ipa成功"

target_path="/Users/zhengguihua/Desktop/SignTimeCMokey/target"
unzip -q "/Users/zhengguihua/Desktop/SignTimeCMokey/target/Target.ipa" -d $target_path &&

/Users/zhengguihua/Desktop/SignTimeCMokey/setbundleid.sh /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey/TargetApp/*.ipa &&

#cd /Users/zhengguihua/Desktop/SignTimeCMokey/target &&
#zip -r finish.ipa Payload &&

#清空builb文件夹下的文件
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/build/Release-iphoneos &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/build/SharedPrecompiledHeaders &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/build/SignTimeCMokey.build &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/build/XCBuildData &&
#清空其他无用临时生成的文件夹
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey/tmp &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/TempPayload &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/SignTimeCMokey/TargetApp/*.app &&
#rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/target/Payload &&
rm -rf /Users/zhengguihua/Desktop/SignTimeCMokey/target/Target.ipa &&
echo "请在target下取finish.ipa文件用neicexia签名"










