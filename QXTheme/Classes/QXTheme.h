//
//  QxTheme.h
//  QXTheme
//
//  Created by lqx on 2018/3/14.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





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


@interface QXTheme : NSObject


/**主题名字*/
@property (nonatomic, copy  ) NSString *name;
/**主题路径*/
@property (nonatomic, strong) NSString *path;
/**默认字体*/
@property (nonatomic, strong) UIFont *defaultFont;




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





- (UIColor *)getColorWithTag:(NSString *)tag;

- (UIImage *)getImgWithTag:(NSString *)tag;

- (UIFont *)getFontWithTag:(NSString *)tag;

- (NSString *)getTextWithTag:(NSString *)tag;

- (id)getOtherWithTag:(NSString *)tag;


@end
