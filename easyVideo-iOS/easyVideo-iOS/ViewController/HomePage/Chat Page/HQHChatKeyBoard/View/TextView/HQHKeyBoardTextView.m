//
//  HQHKeyBoardTextView.m
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import "HQHKeyBoardTextView.h"
#import "HQHKeyBoardDefine.h"

@interface HQHKeyBoardTextView ()

@end

@implementation HQHKeyBoardTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _placeHolder = nil;
        _placeHolderColor = [UIColor colorWithRGB:0x999999];
        self.font = [UIFont systemFontOfSize:16];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = kLineColor.CGColor;
        self.layer.borderWidth = 1.f;
        self.textContainerInset = UIEdgeInsetsMake(7.f, 5.f, 5.f, 5.f);
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewNotification:)
                                                     name:UITextViewTextDidBeginEditingNotification
                                                   object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewNotification:)
                                                     name:UITextViewTextDidEndEditingNotification
                                                   object:self];
    }
    return self;
}

- (void)textViewNotification:(NSNotification *)noti {

    [self setNeedsDisplay];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.placeHolder) {
        [self.placeHolderColor set];
        [self.placeHolder drawInRect:CGRectInset(rect, kHorizenSpace, 7.f) withAttributes:[self placeholderTextAttributes]];
    }
}

- (NSDictionary *)placeholderTextAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *params = @{ NSFontAttributeName : self.font,
                              NSForegroundColorAttributeName : _placeHolderColor,
                              NSParagraphStyleAttributeName : paragraphStyle };
    return params;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
