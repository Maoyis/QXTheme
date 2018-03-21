//
//  CenterVC.m
//  QXTheme_Example
//
//  Created by lqx on 2018/3/16.
//  Copyright © 2018年 Maoyis. All rights reserved.
//

#import "CenterVC.h"
#import "TestVC.h"
@interface CenterVC ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *imgL;
@property (weak, nonatomic) IBOutlet UIImageView *imgR;
@end

@implementation CenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.label qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setTextColor:), @[COLOR_ATTR(@"textColor1")]);
        staff.packing(@selector(setFont:), @[FONT_ATTR(@"labelFont")]);
        staff.packing(@selector(setBackgroundColor:), @[COLOR_ATTR(@"themeColor")]);
        staff.packing(@selector(setText:), @[TEXT_ATTR(@"labelText")]);
    }];
    [self.label.layer qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setCornerRadius:), @[@6]);//偷下懒。这些也可以定制
        staff.packing(@selector(setBorderWidth:), @[@1]);
        staff.packing(@selector(setBorderColor:), @[COLOR_ATTR(@"textColor1")]);
    }];
    [self.btn.layer qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setCornerRadius:), @[@6]);//偷下懒。这些也可以定制
        staff.packing(@selector(setBorderWidth:), @[@1]);
        staff.packing(@selector(setBorderColor:), @[COLOR_ATTR(@"textColor1")]);
    }];
    [self.btn qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setBackgroundColor:), @[COLOR_ATTR(@"themeColor")]);
        staff.packing(@selector(setTitleColor:forState:), @[COLOR_ATTR(@"textColor1"), @(UIControlStateNormal)]);
    }];
    
    [self.imgL qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setImage:), @[]);
    }];
    [self.imgR qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setImage:), @[IMAGE_ATTR(@"imgR")]);
    }];
}



- (IBAction)gotoTest:(id)sender {
    TestVC *vc = [[TestVC alloc] initWithNibName:@"TestVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


}




@end
