//
//  FileManager.h
//  IVPlayer
//
//  Created by nbd on 2017/10/10.
//  Copyright © 2017年 IV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

@property (strong, nonatomic) NSArray *fileArray;
@property (strong, nonatomic, readonly) NSString *fileDirPath;

/**
 单例

 @return 实体
 */
+ (instancetype)shareInstance;

/**
 刷新本地数据
 */
- (void)reloadFileArray;

@end
