//
//  QXThemeManager.m
//  QXTheme
//
//  Created by lqx on 2018/3/13.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import "QXThemeManager.h"



@interface QXThemeManager ()



/**公司业务表*/
@property (nonatomic, strong) NSMapTable *map;

/**快递员*/
@property (nonatomic, strong) QXThemeCourier *courier;
@end


@implementation QXThemeManager


/**
 懒加载业务概况表
 */
- (NSMapTable *)map{
    if (!_map) {
        _map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                         valueOptions:NSPointerFunctionsStrongMemory
                                             capacity:1];
    }
    return _map;
}


#pragma mark===========   API  ===============

+ (QXThemeManager *)shareManager{
    static id manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[self alloc] init];
        [manager setCourier:[QXThemeCourier new]];
    });
    return manager;
}
+ (NSMapTable *)map{
    return [[self shareManager] map];
}


+ (void)refreshMap{
    NSMapTable *map = [[[self shareManager] map] mutableCopy];
    [[self shareManager] setMap:map];
}




+ (void)initDefaultTheme:(QXTheme *)theme{
    [[self shareManager] setCurTheme:theme];
}

/**
 通过文件名配置初始主题
 
 @param fileName 文件全名（包括后缀）
 */
+ (void)initDefaultThemeWithFileName:(NSString *)fileName{
    QXTheme *theme = [[QXTheme alloc] initWithFileName:fileName];
    [self initDefaultTheme:theme];
}


+ (void)changeTheme:(QXTheme *)theme{
    QXThemeManager *m = [self shareManager];
    //更换当前主题
    [m setCurTheme:theme];
    //按客户需求及时更新业务
    [self refreshTheme];
    
}

+ (void)changeThemeWithFileName:(NSString *)fileName{
    QXTheme *theme = [[QXTheme alloc] initWithFileName:fileName];
    [self changeTheme:theme];
}

/**
 修改当前主题
 */
+ (void)changeThemeWithTag:(NSString *)tag
                     value:(id)value
                   tagType:(QXThemeTagType)type{
    [[[self shareManager] curTheme] changeThemeWithTag:tag value:value tagType:type];
    [self refreshTheme];
}

+ (void)refreshTheme{
    QXThemeManager *m = [self shareManager];
    for (QXThemeStaff *staff in [m map].objectEnumerator.allObjects) {
        [m.courier qx_deliverByStaff:staff];
    }
}

#pragma mark===========  业务处理 ===============
- (void)qx_outboundByStaff:(QXThemeStaff *)staff{
    if (!staff || !staff.customer) {//确认是已构建一对一服务的职员
        return;
    }
    if ([self.map.keyEnumerator.allObjects containsObject:staff.customer]) {
        //老客户
        QXThemeStaff *oldStaff = [self.map objectForKey:staff.customer];
        //业务交接
        [oldStaff.packs addObjectsFromArray:staff.packs];
    }else{
        //新客户
        [self.map setObject:staff forKey:staff.customer];
    }
    
    if (self.curTheme) {//确认当前有货才能配送
        //根据职员提供信息配送
        [self.courier qx_deliverByStaff:staff];
    }
}




#pragma mark=========== 取属性值 ===============
/**
 获取对应颜色
 */
+ (UIColor *)getColorWithTag:(NSString *)tag{
    QXTheme *theme = [[self shareManager] curTheme];
    return [theme getColorWithTag:tag]?:[UIColor clearColor];
}
/**
 获取对应图片
 */
+ (UIImage *)getImgWithTag:(NSString *)tag{
    QXTheme *theme = [[self shareManager] curTheme];
    return [theme getImgWithTag:tag]?:[UIImage new];
}
/**
 获取对应字体
 */
+ (UIFont *)getFontWithTag:(NSString *)tag{
    QXTheme *theme = [[self shareManager] curTheme];
    return [theme getFontWithTag:tag]?:[UIFont new];
}

+ (NSString *)getTextWithTag:(NSString *)tag{
    QXTheme *theme = [[self shareManager] curTheme];
    return [theme getTextWithTag:tag]?:@"";
}

+ (id)getOtherWithTag:(NSString *)tag{
    QXTheme *theme = [[self shareManager] curTheme];
    return [theme getOtherWithTag:tag]?:[NSNull new];
}
@end








