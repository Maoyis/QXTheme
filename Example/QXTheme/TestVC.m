//
//  TestVC.m
//  QXTheme_Example
//
//  Created by lqx on 2018/3/16.
//  Copyright © 2018年 Maoyis. All rights reserved.
//

#import "TestVC.h"

static NSString *identy = @"QXTheme";

@interface TestVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *col;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义";
    [self.col registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identy];
    [self initLayout];
    [self setNav];
    
    
}

- (void)setNav{
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtn qx_OrderPacks:^(QXThemeStaff *staff) {
        staff.packing(@selector(setTitleColor:forState:),
                      @[COLOR_ATTR(@"tabbar_selectColor"),
                        @(UIControlStateNormal)]);
    }];
    [rBtn setFrame:CGRectMake(0, 0, 60, 30)];
    [rBtn setTitle:@"切换主题" forState:UIControlStateNormal];
    [rBtn addTarget:self action:@selector(changeTheme) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)changeTheme{
    NSString *name = @"Theme_Night.json";
    if ([[QXThemeManager shareManager].curTheme.name isEqualToString:@"Theme_Night"]) {
        name = @"Theme_Day.plist";
    }
    [QXThemeManager changeThemeWithFileName:name];
}


- (void)initLayout{
    CGFloat winWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(winWidth/4, winWidth/4);
    
    layout.minimumLineSpacing      = winWidth/17;
    layout.minimumInteritemSpacing = winWidth/17;
    
    layout.sectionInset  = UIEdgeInsetsMake(winWidth/17, winWidth/17, 0, winWidth/17);
    
    [self.col setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identy forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1.f;
    cell.layer.cornerRadius = 5;
    
    return cell;
    
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIColor *color = cell.backgroundColor;
    NSString *hexStr = [UIColor qx_hexStringWithColor:color];
    [QXThemeManager changeThemeWithTag:@"themeColor" value:hexStr tagType:QXThemeTagTypeOfColor];
    [QXThemeManager saveChange];
    NSError *error;
    if (![[QXThemeManager shareManager].curTheme exportThemeFileWithFileType:QXThemeFileTypeJson name:@"Theme_color" path:@"/Users/lqx/Desktop/QXTheme" error:&error]) {
        NSLog(@"导出失败Error:%@", error.localizedDescription);
    }
}


@end
