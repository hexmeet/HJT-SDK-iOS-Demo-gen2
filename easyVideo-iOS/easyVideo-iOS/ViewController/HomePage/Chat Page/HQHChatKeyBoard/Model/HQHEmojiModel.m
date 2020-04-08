//
//  HQHEmojiModel.m
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import "HQHEmojiModel.h"

@implementation HQHFaceModel

@end

@implementation HQHEmojiModel

@end

@implementation HQHGroupEmojiModel

+ (instancetype)initEmojiWithPlist:(NSString *)plist image:(NSString *)image {
    
    NSString *path = [NSBundle.mainBundle pathForResource:plist ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray<HQHEmojiModel *> *temArr = [NSMutableArray array];
    
    //读取plist里面的文字表情
    for (NSString *title in array) {
        HQHEmojiModel *model = [HQHEmojiModel new];
        model.title = title;
        [temArr addObject:model];
    }
    
    NSInteger singlePage = kSmallEmojiRow * kSmallEmojiCol - 1;
    NSInteger page = ceil(array.count / (CGFloat)singlePage);
    
    //将不够最后一页的地方补上空模型对象，为了让删除按钮在最后
    for (int i = 0; i < page * singlePage - array.count; i++) {
        HQHEmojiModel *model = [HQHEmojiModel new];
        [temArr addObject:model];
    }
    
    //将删除按钮已插入的形式放入数组
    for (int i = 0; i < page; i++) {
        HQHEmojiModel *model = [HQHEmojiModel new];
        model.image = @"icon_emoji_delete";
        [temArr insertObject:model atIndex:(i+1) * singlePage + i];
    }
    
    HQHGroupEmojiModel *groupModel = [HQHGroupEmojiModel new];
    groupModel.groupImage = image;
    groupModel.emojis = temArr;
    groupModel.type = HQHChatEmojiSmall;
    groupModel.totalPages = page;
    
    return groupModel;
}

+ (instancetype)initEmojiWithPlist:(NSString *)plist fileName:(NSString *)fileName image:(NSString *)image {
    
    NSString *path = [NSBundle.mainBundle pathForResource:plist ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray<HQHEmojiModel *> *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        HQHEmojiModel *model = [HQHEmojiModel new];
        model.image = [NSString stringWithFormat:@"%@%d.png", fileName, i+1];
        model.title = array[i][@"name"];
        
        [tempArr addObject:model];
    }
    
    NSInteger singlePage = kSmallEmojiRow * kSmallEmojiCol - 1;
    NSInteger page = ceil(tempArr.count / (CGFloat)singlePage);
    
    //将不够最后一页的地方补上空模型（无title&image）对象，为了让删除按钮在最后
    for (int i = 0; i < page * singlePage - array.count; i++) {
        HQHEmojiModel *model = [HQHEmojiModel new];
        [tempArr addObject:model];
    }
    
    //将删除按钮已插入的形式放入数组
    for (int i = 0; i < page; i++) {
        HQHEmojiModel *model = [HQHEmojiModel new];
        model.image = @"icon_emoji_delete";
        model.title = @"delete";
        [tempArr insertObject:model atIndex:(i+1) * singlePage + i];
    }
    
    HQHGroupEmojiModel *groupModel = [HQHGroupEmojiModel new];
    groupModel.emojis = tempArr;
    groupModel.groupImage = image;
    groupModel.type = HQHChatEmojiSmall;
    groupModel.totalPages = page;
    
    return groupModel;
}

+ (instancetype)initFaceWithFileName:(nullable NSString *)name count:(NSInteger)count image:(NSString *)image {
    
    NSMutableArray<HQHFaceModel *> *tempArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        HQHFaceModel *model = [HQHFaceModel new];
        if (!name) {
            model.image = [NSString stringWithFormat:@"%03d.png", i];
        }else {
            model.image = [NSString stringWithFormat:@"%@%d.jpg", name, i];
        }
        
        [tempArr addObject:model];
    }
    
    HQHGroupEmojiModel *groupModel = [HQHGroupEmojiModel new];
    groupModel.faces = tempArr;
    groupModel.groupImage = image;
    groupModel.type = HQHChatEmojiBig;
    groupModel.totalPages = ceil(count / (CGFloat)(kBigEmojiRow * kBigEmojiCol));
    
    return groupModel;
}

@end

