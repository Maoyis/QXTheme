//
//  QXThemeManager.h
//  QXTheme
//
//  Created by lqx on 2018/3/13.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXTheme.h"
#import "QXThemeCourier.h"
#import "QXThemeStaff.h"


#define QX_COLOR(tag)  [QXThemeManager getColorWithTag:tag]
#define QX_IMG(tag)    [QXThemeManager getImgWithTag:tag]
#define QX_FONT(tag)   [QXThemeManager getFontWithTag:tag]
#define QX_TEXT(tag)   [QXThemeManager getTextWithTag:tag]
#define QX_OTHER(tag)  [QXThemeManager getOtherWithTag:tag]



/**
 角色：主题店老板
 员工：打包工、快点员、设计师、客服
 功能：
 1、加载主题文件，配置主题
 2、管理主题，增删改查
 3、否则切换
 
 */
@interface QXThemeManager : NSObject


/** 当前主题  */
@property (nonatomic, strong) QXTheme *curTheme;

/** 全局键盘样式 */
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;
/** 修改键盘样式权限，默认YES-能修改*/
@property (nonatomic, assign) BOOL authKeyboardAppearance;

/**
 获取全局主题管理
 */
+ (instancetype)shareManager;


/**
 获取当前UI(客户)注册表
 */
+ (NSMapTable *)map;


#pragma mark===========   API  ===============
/**
 配置初始主题
 */
+ (void)initDefaultTheme:(QXTheme *)theme;

/**
 通过文件名配置初始主题
 
 @param fileName 文件全名（包括后缀）
 @param isPriorityDefault 是否优先以上一次主题初始默认主题
 */
+ (void)initDefaultThemeWithFileName:(NSString *)fileName isPriorityDefault:(BOOL)isPriorityDefault;
/**
 通过文件名配置初始主题

 @param fileName 文件全名（包括后缀）
 */
+ (void)initDefaultThemeWithFileName:(NSString *)fileName;


/**
 切换主题
 */
+ (void)changeTheme:(QXTheme *)theme;
/**
 通过文件名切换主题
 
 @param fileName 文件全名（包括后缀）
 */
+ (void)changeThemeWithFileName:(NSString *)fileName;
/**
 修改当前主题(不会修改文件内容，临时生效)
 */
+ (void)changeThemeWithTag:(NSString *)tag
                     value:(id)value
                   tagType:(QXThemeTagType)type;
/**
 保存当前修改（只会替换默认文件，不修改原文件）
 */
+ (void)saveChange;
/**
 刷新主题
 */
+ (void)refreshTheme;


/**
 通过主题（文件）名字比较当前主题是否为某个主题
 
 @param name 主题名字
 @return YES-相同主题
 */
+ (BOOL)compareCurThemeWithName:(NSString *)name;


#pragma mark=========== 业务处理 ===============

/**
 根据职员信息配货出库(根据信息定制UI)
 */
- (void)qx_outboundByStaff:(QXThemeStaff *)staff;

/**
 取消订阅
 */
- (void)qx_cancelByStaff:(QXThemeStaff *)staff ;
- (void)qx_cancelByCustomer:(id)customer sel:(SEL)sel;
#pragma mark=========== 取属性值 ===============
/**
 获取主题对应颜色
 */
+ (UIColor *)getColorWithTag:(NSString *)tag;
/**
 获取主题对应图片
 */
+ (UIImage *)getImgWithTag:(NSString *)tag;
/**
 获取主题对应字体
 */
+ (UIFont *)getFontWithTag:(NSString *)tag;
/**
 获取主题对应文本
 */
+ (NSString *)getTextWithTag:(NSString *)tag;
/**
 获取主题对应其他属性
 */
+ (id)getOtherWithTag:(NSString *)tag;

@end






















































































































































































































































































































































































































































































































































































