//
//  FileManager.m
//  IVPlayer
//
//  Created by nbd on 2017/10/10.
//  Copyright © 2017年 IV. All rights reserved.
//

#import "FileManager.h"

@interface FileManager() {
    NSString *_fileDirPath;
}

@end

@implementation FileManager

+ (instancetype)shareInstance {
    static FileManager *instence = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instence = [FileManager new];
    });
    return instence;
}

- (id)init {
    self = [super init];
    if (self) {
        [self reloadFileArray];
    }
    return self;
}

- (NSString *)fileDirPath {
    if (!_fileDirPath) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _fileDirPath = [path stringByAppendingString:@"/video/"];
    }
    return _fileDirPath;
}

- (void)reloadFileArray {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:self.fileDirPath isDirectory:nil];
    if (isExist) {
        _fileArray = [fileManager subpathsAtPath:self.fileDirPath];
    }
}

@end
