//
//  NSObject+QXThemeOrder.h
//  QXTheme
//
//  Created by lqx on 2018/3/14.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXThemeStaff.h"
#import "QXThemeManager.h"


/**
 订购业务

 @param staff 业务职员
 */
typedef void(^QXOrderPacks)(QXThemeStaff *staff);
/**
 主题平台开放的订购功能
 */
@interface NSObject (QXThemeOrder)




- (void)qx_OrderPacks:(QXOrderPacks)OrderPacks;


@end


