//
//  UploadManager.h
//  IVPlayer
//
//  Created by nbd on 2017/9/30.
//  Copyright © 2017年 IV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadManager : NSObject

/**
 单例

 @return UploadManager
 */
+ (instancetype)shareInstance;

/**
 开始监听
 */
- (void)startObserver;


/**
  开始监听

 @param block 服务器地址
 */
- (void)startObserverWithBlock:(void(^)(NSString *)) block;

/**
 结束监听
 */
- (void)endObserver;

@end
