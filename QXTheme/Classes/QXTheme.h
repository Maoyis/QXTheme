//
//  QxTheme.h
//  QXTheme
//
//  Created by lqx on 2018/3/14.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define DEFAULT_THEME_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ThemeFile"]


@interface UIColor (QXColorString)
/**
 hexStr->color
 */
+ (UIColor *)qx_colorWithHexString:(NSString *)hexString;

/**
 color->hexStr
 */
+ (NSString *)qx_hexStringWithColor:(UIColor *)color;
@end




typedef NS_ENUM(NSInteger, QXThemeTagType) {
    QXThemeTagTypeOfRoot,
    QXThemeTagTypeOfColor,
    QXThemeTagTypeOfImage,
    QXThemeTagTypeOfFont,
    QXThemeTagTypeOfText,
    QXThemeTagTypeOfOther,
};

typedef NS_ENUM(NSInteger, QXThemeFileType) {
    QXThemeFileTypeJson,
    QXThemeFileTypePlist,
};


@interface QXTheme : NSObject


/**主题名字*/
@property (nonatomic, copy  ) NSString *name;
/**主题路径*/
@property (nonatomic, strong) NSString *path;
/**默认字体*/
@property (nonatomic, strong) UIFont *defaultFont;



/**
 通过文件路径初始一个主题

 @param path 文件路径
 @return 主题实例
 */
- (instancetype)initWithFilePath:(NSString *)path;
/**
 通过文件名初始一个主题

 @param filename 文件名（带后缀，eg：theme.plist）
 @return 主题实例
 */
- (instancetype)initWithFileName:(NSString *)filename;


/**
 修改主题
 */
- (QXTheme *)changeThemeWithTag:(NSString *)tag
                     value:(id)value
                   tagType:(QXThemeTagType)type;


#pragma mark=========== 文件操作 ===============


/**
 导出当前主题为相应类型文件
 
 @param type 导出文件类型
 @param error 错误指针
 return 是否成功导出文件，YES：成功
 */
- (BOOL)exportThemeFileWithFileType:(QXThemeFileType)type error:(NSError **)error;
/**
 导出当前主题为相应类型文件
 
 @param type  导出文件类型
 @param name  新文件名
 @param error 错误指针
 return 是否成功导出文件，YES：成功
 */
- (BOOL)exportThemeFileWithFileType:(QXThemeFileType)type name:(NSString *)name error:(NSError **)error;
/**
 导出主题文件
 
 @param type 导出文件类型（默认为Json）
 @param name 导出文件的新名字
 @param path 导出文件存储目录
 @param error 错误指针
 return 是否成功导出文件，YES：成功
 */
- (BOOL)exportThemeFileWithFileType:(QXThemeFileType)type name:(NSString *)name path:(NSString *)path error:(NSError **)error;





#pragma mark=========== 属性匹配 ===============
- (UIColor *)getColorWithTag:(NSString *)tag;

- (UIImage *)getImgWithTag:(NSString *)tag;

- (UIFont *)getFontWithTag:(NSString *)tag;

- (NSString *)getTextWithTag:(NSString *)tag;

- (id)getOtherWithTag:(NSString *)tag;


@end
