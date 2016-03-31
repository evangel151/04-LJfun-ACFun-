//
//  VideoModel.h
//  04-LJfun(山寨ACFun)
//
//  Created by  a on 16/3/31.
//  Copyright © 2016年 eva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
/**
 "id": 1,
 "image": "resources/images/minion_01.png",
 "length": 10,
 "name": "小黄人 第01部",
 "url": "resources/videos/minion_01.mp4"
 */
/**
*  ID
*/
@property (nonatomic, assign) int id;
/**
 *  视频截图
 */
@property (nonatomic, copy) NSString *image;
/**
 *  视频时长
 */
@property (nonatomic, assign) int length;
/**
 *  视频名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  视频播放路径
 */
@property (nonatomic, copy) NSString *url;

// - (instancetype)initWithDict:(NSDictionary *)dict;

// 创建一个类方法 便于快速创建
+ (instancetype)videoModelWithDict:(NSDictionary *)dict;

@end
