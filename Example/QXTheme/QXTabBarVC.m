//
//  QXTabBarVC.m
//  QXTheme_Example
//
//  Created by lqx on 2018/3/16.
//  Copyright © 2018年 Maoyis. All rights reserved.
//

#import "QXTabBarVC.h"






@interface QXTabBarVC ()

@end

@implementation QXTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    
   
}



- (void)setBar{
    [self.tabBar qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.
        packing(@selector(setBarTintColor:),
                @[COLOR_ATTR(@"themeColor")]).
        packing(@selector(setTintColor:),
                @[COLOR_ATTR(@"tabbar_selectColor")]).
        packing(@selector(setUnselectedItemTintColor:),
                @[COLOR_ATTR(@"tabbar_tintColor")]);
    }];
    for (int i=0 ; i<self.viewControllers.count; i++) {
        UIViewController *vc = self.viewControllers[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        UITabBarItem *item = [[UITabBarItem alloc] init];
        vc.tabBarItem = item;
        NSString *name  = [NSString stringWithFormat: @"tabbar%d", i+1];
        NSString *names = [NSString stringWithFormat: @"tabbar_s%d", i+1];
        [item qx_OrderPacks:^(QXThemeStaff *staff) {
            staff.packing(@selector(setTitle:), @[TEXT_ATTR(name)]);
            staff.packing(@selector(setImage:), @[IMAGE_ATTR(name)]);
            staff.packing(@selector(setSelectedImage:),
                          @[IMAGE_ATTR(names)]);
        }];
        UINavigationController *nav = (UINavigationController *)vc;
        [nav.viewControllers.lastObject qx_OrderPacks:^(QXThemeStaff *staff) {
            staff.packing(@selector(setTitle:), @[TEXT_ATTR(name)]);
        }];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
