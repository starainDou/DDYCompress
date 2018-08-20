#import <Foundation/Foundation.h>

extern NSErrorDomain DDYCompressDomain;
#define DDYCompressSuccess  0    // 解压成功
#define DDYCompressNoFile   -1   // 文件不存在
#define DDYCompressNoFile   -1   // 文件不存在

@interface DDYCompress : NSObject

// !!!: 解压:Decompress
typedef void(^Complete)(NSError *error, NSString *destPath);

/**
 解压
 @param filePath 原压缩文件路径
 @param destPath 解压到目的路径(为nil或无法创建指定目的路径,则使用document下filePath同名文件夹路径)
 @param password 压缩包解压密码(无密码传nil)
 @param complete 结果回调
 */
+ (void)ddy_DecopressFile:(NSString *)filePath
          destinationPath:(NSString *)destPath
                 password:(NSString *)password
                 complete:(Complete)complete;

// 压缩:Compress

@end

/**
 !!!: 这只是demo
 MARK:这里算是程序内解压,是程序需要解压,事先知道有无密码,路径为带后缀的本地路径
 FIXME:如果想做成解压软件,需要自行完善
 TODO:如先判断是否有密码,判断路径是否带有后缀,是否是大文件(比如大于500M)等
 */
