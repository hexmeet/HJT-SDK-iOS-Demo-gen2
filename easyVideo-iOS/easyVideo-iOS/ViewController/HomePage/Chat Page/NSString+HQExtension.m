//
//  NSString+HQExtension.m
//  HexMeet
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import "NSString+HQExtension.h"

@implementation NSString (HQExtension)
-(CGSize) sizeWithFont:(UIFont *) font maxSize:(CGSize) maxSize
{
    NSDictionary *dict  = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return  textSize;
}
@end
