//
//  Global.h
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#ifndef Global_h
#define Global_h

#define HQInitH(name) \
- (instancetype) initWithDict:(NSDictionary *) dict;\
+ (instancetype) name##WithDict:(NSDictionary *) dict;

#define HQNameH(name)\
-(instancetype)initWithDict:(NSDictionary *)dict\
{\
    if (self = [super init]) {\
        [self setValuesForKeysWithDictionary:dict];\
    }\
    return self;\
}\
+(instancetype)name##WithDict:(NSDictionary *)dict\
{\
    return [[self alloc] initWithDict:dict];\
}

#endif /* Global_h */
