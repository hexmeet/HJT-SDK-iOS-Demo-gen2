#!/bin/bash

# customize.sh

# 替换 App 显示在系统中名字
sed -i "" -e "s/easyVideo/好应用/g"    ../easyVideo-iOS/easyVideo-iOS/zh-Hans.lproj/InfoPlist.strings
sed -i "" -e "s/easyVideo/GreatAPP/g"  ../easyVideo-iOS/easyVideo-iOS/en.lproj/InfoPlist.strings

# 替换版权信息显示的公司名字，根据需要您还可以替换更多文字
sed -i "" -e "s/easyVideo Company/伟大的公司/g"     ../easyVideo-iOS/easyVideo-iOS/zh-Hans.lproj/InfoPlist.strings
sed -i "" -e "s/easyVideo Company/Great Company/g"  ../easyVideo-iOS/easyVideo-iOS/en.lproj/InfoPlist.strings

# 替换应用 Logo，根据具体需要您还可以替换 easyVideo-iOS/easyVideo-iOS/Assets.xcassets/ 下的更多其它图片文件
cp -af ./AppIcon.appiconset/* ../easyVideo-iOS/easyVideo-iOS/Assets.xcassets/AppIcon.appiconset/
cp -af ./NeedReplace/*        ../easyVideo-iOS/easyVideo-iOS/Assets.xcassets/NeedReplace/
cp -af ./ipx.imageset/*       ../easyVideo-iOS/easyVideo-iOS/Assets.xcassets/ipx.imageset/

# 替换 版本号\Bundle ID\Bundle Name 等信息
export BUNDLE_IDENTIFIER="com.yourcompany.greatapp"
export PRODUCT_NAME="GreatApp"
 
BUILD_NUMBER=1 
RELEASE_NUM=1.0
export VERSION=${RELEASE_NUM}.${BUILD_NUMBER}

cd ../easyVideo-iOS/
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${VERSION}" ./easyVideo-iOS/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${BUNDLE_IDENTIFIER}" ./easyVideo-iOS/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleName ${PRODUCT_NAME}" ./easyVideo-iOS/Info.plist


