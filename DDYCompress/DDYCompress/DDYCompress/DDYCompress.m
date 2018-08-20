#import "DDYCompress.h"
//#import <SSZipArchive/SSZipArchive.h>
//#import <UnrarKit/UnrarKit.h>
//#import <LzmaSDK_ObjC/LzmaSDKObjC.h>

@import SSZipArchive;
@import UnrarKit;
@import LzmaSDK_ObjC;

NSErrorDomain DDYCompressDomain = @"DDYCompressDomain";


@interface DDYCompress ()
/** 压缩文件的路径 */
@property (nonatomic, strong) NSString *filePath;
/** 解压到的目的文件夹路径 */
@property (nonatomic, strong) NSString *destinationPath;
/** 解压密码 */
@property (nonatomic, strong) NSString *password;

@end


@implementation DDYCompress

+ (void)ddy_DecopressFile:(NSString *)filePath destinationPath:(NSString *)destPath password:(NSString *)password complete:(Complete)complete
{
    if (filePath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:DDYCompressDomain code:DDYCompressNoFile userInfo:@{@"reason":@"No file"}];
            complete(error ,nil);
        }
    } else {
        if (!destPath || ![[NSFileManager defaultManager] createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSString *documenPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            destPath = [documenPath stringByAppendingPathComponent:[[filePath lastPathComponent] stringByDeletingPathExtension]];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:destPath error:nil];
        }
        if ([filePath hasSuffix:@".rar"]) {
            [self rarDecompress:filePath destinationPath:destPath password:password complete:complete];
        } else if ([filePath hasSuffix:@".zip"]) {
            [self zipDecompress:filePath destinationPath:destPath password:password complete:complete];
        } else if ([filePath hasSuffix:@".7z"]) {
            [self sevenZDecompress:filePath destinationPath:destPath password:password complete:complete];
        }
    }
}

#pragma mark rar UnArchive
+ (void)rarDecompress:(NSString *)filePath destinationPath:(NSString *)destPath password:(NSString *)password complete:(Complete)complete {
    void (^handleResult)(NSError *, NSString *) = ^(NSError *error, NSString *destPath) {
        if (complete) {
            complete(error ,destPath);
        }
    };
    NSError *error = nil;
    URKArchive *archive = [[URKArchive alloc] initWithPath:filePath password:password error:&error];
    if (error) {
        handleResult(error, nil);
        return;
    }
    NSArray *fileNameArray = [archive listFilenames:&error];
    if (error) {
        handleResult(error, nil);
        return;
    }
    [archive extractDataFromFile:fileNameArray[0] progress:nil error:&error];
    if (error) {
        handleResult(error, nil);
        return;
    }
    [archive extractFilesTo:destPath overwrite:NO progress:^(URKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) { } error:&error];
    handleResult(error, destPath);
}

#pragma mark zip UnArchive
+ (void)zipDecompress:(NSString *)filePath destinationPath:(NSString *)destPath password:(NSString *)password complete:(Complete)complete {
    [SSZipArchive unzipFileAtPath:filePath
                    toDestination:destPath
                        overwrite:NO
                         password:password
                  progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) { }
                completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                    if (complete) {
            complete(error, destPath);
        }
    }];
}

#pragma mark 7z UnArchive
+ (void)sevenZDecompress:(NSString *)filePath destinationPath:(NSString *)destPath password:(NSString *)password complete:(Complete)complete {
    LzmaSDKObjCReader *reader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
    [reader setPasswordGetter:^NSString * _Nullable{
        return password;
    }];
    NSError *error;
    if (![reader open:&error]) {
        if (complete) {
            complete(error, nil);
        }
    }
    NSMutableArray *itemArray = [NSMutableArray array];
    [reader iterateWithHandler:^BOOL(LzmaSDKObjCItem * _Nonnull item, NSError * _Nullable error) {
        if (item) {
            [itemArray addObject:item];
            return YES;
        } else {
            return NO;
        }
    }];
    [reader extract:itemArray toPath:destPath withFullPaths:YES];
    if (complete) {
        complete(reader.lastError, destPath);
    }
}
@end
/**
 !!!:https://github.com/OlehKulykov/LzmaSDKObjC
 !!!:https://github.com/ZipArchive/ZipArchive
 !!!:https://github.com/abbeycode/UnrarKit
 */
