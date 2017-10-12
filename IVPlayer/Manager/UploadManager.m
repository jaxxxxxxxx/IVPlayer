//
//  UploadManager.m
//  IVPlayer
//
//  Created by nbd on 2017/9/30.
//  Copyright © 2017年 IV. All rights reserved.
//

#import "UploadManager.h"
#import <GCDWebServer/GCDWebUploader.h>

@interface UploadManager() {
    GCDWebUploader *_webUploader;
}

@end

@implementation UploadManager

+ (instancetype)shareInstance {
    static UploadManager *instence = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instence = [UploadManager new];
    });
    return instence;
}

- (id)init {
    self = [super init]; 
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingString:@"/video"];
        
        BOOL isDir = NO;
        BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
        
        if (!(isDir == YES && isExist == YES)) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:path];
       
    }
    return self;
}

- (void)startObserver {
    [self startObserverWithBlock:nil];
}

- (void)startObserverWithBlock:(void(^)(NSString *)) block{
    if (_webUploader.isRunning) {
        return;
    }
    
    // Start server
    [_webUploader startWithPort:2963 bonjourName:nil];
    
    if (block) {
        block(_webUploader.serverURL.absoluteString);
    }
}

- (void)endObserver {
    [_webUploader stop];
}

@end
