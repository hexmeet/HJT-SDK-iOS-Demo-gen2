//
//  MessageFrameModel.m
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import "MessageFrameModel.h"
#import "NSString+HQExtension.h"



@implementation MessageFrameModel

-(void)setMessage:(MessageModel *)message
{
    _message = message;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat padding = 10;
    //1.时间
    if (NO == _message.hiddenTime) {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeH = 30;
        CGFloat tiemW = screenWidth;
        _timeF = CGRectMake(timeX, timeY, tiemW, timeH);
    }
    
    //2.头像
    CGFloat iconH = 40;
    CGFloat iconW = 40;
    CGFloat iconY = CGRectGetMaxY(_timeF) + padding;
    CGFloat iconX = 0;
    if (MessageModelTypeMe == _message.type) {
        iconX = screenWidth - padding - iconW;
    }
    else
    {
        iconX = padding;
    }
    
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    //3.名字
    CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    CGFloat nameH = [message.name sizeWithFont:[UIFont systemFontOfSize:11] maxSize:maxSize].height;
    CGFloat nameW = [message.name sizeWithFont:[UIFont systemFontOfSize:11] maxSize:maxSize].width;
    CGFloat nameX = 0;
    if (MessageModelTypeMe == _message.type) {
        nameX = screenWidth - padding - nameW;
    }
    else
    {
        nameX = padding;
    }
    
    _nameF = CGRectMake(nameX, iconY, nameW, nameH);
    
    //4.正文
    CGSize textSize = [_message.content sizeWithFont:HQTextFont maxSize:maxSize];
    CGFloat textW = textSize.width + HQEdgeInsets * 2;
    CGFloat textH = textSize.height + HQEdgeInsets * 2;
    CGFloat textY = iconY;
    CGFloat textX = 0;
    if (MessageModelTypeMe == _message.type) {
        // 自己发的
        // x = 头像x - 间隙 - 文本的宽度
        textX = screenWidth - textW;
    }
    else
    {
        //别人发的
        textX = padding-10;
    }
    
    self.textF = CGRectMake(textX, textY+8, textW, textH);
    
    CGFloat maxIconY = CGRectGetMaxY(_iconF);
    CGFloat maxTextY = CGRectGetMaxY(_textF);
    
    self.cellHeight = MAX(maxIconY, maxTextY) + padding;
    
}

@end
