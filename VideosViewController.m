//
//  VideosViewController.m
//  04-LJfun(山寨ACFun)
//
//  Created by  a on 16/3/31.
//  Copyright © 2016年 eva. All rights reserved.
//

#define LJURL(path)  [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8080/MJServer/%@",path]]
#import "VideosViewController.h"
#import "MBProgressHUD+MJ.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"
#import "GDataXMLNode.h"
// 苹果自带的视频播放器头文件 / iOS9已不推荐使用
#import <MediaPlayer/MediaPlayer.h>

@interface VideosViewController ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *videos;
@end

@implementation VideosViewController

- (NSMutableArray *)videos {
    if (!_videos) {
        self.videos = [NSMutableArray array];
    }
    return _videos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 界面加载完毕后，应该加载服务器最新的视频信息
    // 1. 创建URL
    NSURL *url            = LJURL(@"video?type=XML");
    // 2. 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // 3. 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 3.1 对服务器返回的数据进行判断
        if (connectionError || data == nil) {
            [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
            return;
        }
#warning The diffence of XML and JSON
#if 0
        "本质是一样的，只是创建请求时候要求服务器返回的数据格式不一样，连带解析方法也不一样"
#endif
        // 4. 解析XML文档 (使用NSXMLParser进行解析)
        // 4.1 创建XML解析器  --(SAX模式) 逐个元素往下进行解析
        NSXMLParser *parser   = [[NSXMLParser alloc] initWithData:data];

        // 4.2 设置代理 (使用控制器作为解析器的代理)
        parser.delegate       = self;
        // 开始进行解析 (同步执行) --> (解析和刷新是同步执行，刷新表格的时候 cell内肯定是有数据的)
        [parser parse];

        // 5. 刷新表格
        [self.tableView reloadData];

    }];
}

#pragma mark - NSXMLParser 的代理方法
/**
 *  解析到文档的开头时会调用 (开始解析)
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
}

/**
解析到一个元素开始时候就会调用
 *  @param elementName   元素名称
 *  @param attributeDict 属性字典
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    // 如果解析的是XML文档的声明  直接返回
    if ([@"videos" isEqualToString:elementName]) {
        return;
    }
    
    // 解析各个元素 (可以使用KVC进行赋值)
    VideoModel *video = [VideoModel videoModelWithDict:attributeDict];
    [self.videos addObject:video];
}

/**
 解析到一个元素结束的时候就会调用
 *  @param elementName   元素名称
 *  @param attributeDict 属性字典
 */

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

}

/**
 *  解析到文档的结尾时会调用 (解析结束)
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"videos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 设置cell的属性
    VideoModel *video = self.videos[indexPath.row];
    
    cell.textLabel.text = video.name;
    NSURL *url = LJURL(video.image);
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"视频时长: %d秒", video.length];
    
#warning change cell.imageView.frame.size to fixed value / 修改图片的尺寸为固定值
    // 修改cell.imageView 为固定尺寸
    CGSize size          = CGSizeMake(85, 40);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGRect imageRect     = CGRectMake(0, 0, size.width, size.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // cell.imageView.bounds = CGSizeMake(0, 0);
    return cell;

}

#pragma mark - 代理方法 (监听cell的点击)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 取出对应的视频模型 (根据行号取出视频)
    VideoModel *video = self.videos[indexPath.row];
    
    // 播放视频 (最简单的方法: 直接调用系统提供的视频播放器)
    // 2. 创建播放器 并设置播放的视频的路径
    NSURL *url = LJURL(video.url);
    MPMoviePlayerViewController *playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    // 3. 显示播放器
    [self presentViewController:playerVc animated:YES completion:nil];
    
}


@end
