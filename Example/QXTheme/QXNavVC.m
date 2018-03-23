//
//  QXNavVC.m
//  QXTheme_Example
//
//  Created by lqx on 2018/3/16.
//  Copyright © 2018年 Maoyis. All rights reserved.
//

#import "QXNavVC.h"

@interface QXNavVC ()

@end

@implementation QXNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}

- (void)setNavBar{
    
    [self.navigationBar qx_OrderPacks:^(QXThemeStaff *staff) {
       staff.
        packing(@selector(setTranslucent:), @[OTHER_ATTR(@"nav_translucent")]).
        packing(@selector(setBarTintColor:), @[COLOR_ATTR(@"themeColor")]).
        packing(@selector(setTintColor:), @[COLOR_ATTR(@"tabbar_selectColor")]);
        
        staff.packing(@selector(setTitleTextAttributes:),
                      @[@{NSFontAttributeName:FONT_ATTR(@"navTitle"),
                          NSForegroundColorAttributeName:COLOR_ATTR(@"tabbar_selectColor")}]);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return [QX_OTHER(@"BarStyle") integerValue];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
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
