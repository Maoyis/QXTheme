//
//  NSObject+QXThemeOrder.m
//  QXTheme
//
//  Created by lqx on 2018/3/14.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import "NSObject+QXThemeOrder.h"



@implementation NSObject (QXThemeOrder)



/**
 下单
 */
- (void)qx_OrderPacks:(QXOrderPacks)orderPacks{
    QXThemeStaff *staff = [QXThemeStaff new];
    //订购业务
    orderPacks(staff);
    staff.customer = self;
    QXThemeManager *m = [QXThemeManager shareManager];
    //根据职员提供信息出库
    [m qx_outboundByStaff:staff];
}



- (void)qx_CancelOrderPacks:(QXOrderPacks)orderPacks {
    QXThemeStaff *staff = [QXThemeStaff new];
    //退订业务
    orderPacks(staff);
    staff.customer = self;
    QXThemeManager *m = [QXThemeManager shareManager];
    //根据职员提供信息出库
    [m qx_cancelByStaff:staff];
}

- (void)qx_CancelOrderPacksWithSel:(SEL)sel{
    QXThemeManager *m = [QXThemeManager shareManager];
    //根据职员提供信息出库
    [m qx_cancelByCustomer:self sel:sel];
}

@end





