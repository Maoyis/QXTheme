//
//  QXViewController.m
//  QXTheme
//
//  Created by Maoyis on 03/16/2018.
//  Copyright (c) 2018 Maoyis. All rights reserved.
//

#import "QXViewController.h"


@interface QXViewController ()

@end



@implementation QXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setBackgroundColor:), @[COLOR_ATTR(@"themeColor")]);
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
