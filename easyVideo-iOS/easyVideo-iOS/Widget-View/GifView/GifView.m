//
//  GifView.m
//  EasyVideo
//
//  Created by quanhao huang on 2018/7/7.
//  Copyright © 2018年 fo. All rights reserved.
//

#import "GifView.h"

@implementation GifView

- (void)loadImagefilePath:(NSString *)_filePath
{
    gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                 forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
    gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
    count =CGImageSourceGetCount(gif);
    timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
    [timer fire];
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath{
    if (self) {
        
        gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                     forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSData *)_data{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                     forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        gif = CGImageSourceCreateWithData((CFDataRef)_data, (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

- (void)play
{
    index ++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    self.layer.contents = (id)ref;
    CFRelease(ref);
}

- (void)removeFromSuperview
{
    NSLog(@"removeFromSuperview");
    [timer invalidate];
    timer = nil;
    [super removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"dealloc");
    CFRelease(gif);
    [gifProperties release];
    [super dealloc];
}

@end
