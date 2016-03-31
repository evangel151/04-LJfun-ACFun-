//
//  VideoModel.m
//  04-LJfun(山寨ACFun)
//
//  Created by  a on 16/3/31.
//  Copyright © 2016年 eva. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
+ (instancetype)videoModelWithDict:(NSDictionary *)dict {
    VideoModel *video = [[self alloc] init];
    
    [video setValuesForKeysWithDictionary:dict];
    
    return video;
}


@end
