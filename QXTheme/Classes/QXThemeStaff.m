//
//  QXThemePacker.m
//  QXTheme
//
//  Created by lqx on 2018/3/13.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import "QXThemeStaff.h"



@implementation QXThemePack

- (QXSelSetter)setSel{
    return ^(SEL  sel){
        self.sel = sel;
        return self;
    };
}

- (QXArgsSetter)setArgs{
    return ^(NSArray *args){
        self.args = args;
        return self;
    };
}
@end

@implementation QXThemeAttr

+ (QXAttrTagSetter)colorTag{
    return ^(NSString *tag){
        QXThemeAttr *attr = [self new];
        attr.tag    = tag;
        attr.type   = QXThemeAttrTypeOfColor;
        return attr;
    };
}
+ (QXAttrTagSetter)fontTag{
    return ^(NSString *tag){
        QXThemeAttr *attr = [self new];
        attr.tag    = tag;
        attr.type   = QXThemeAttrTypeOfFont;
        return attr;
    };
}
+ (QXAttrTagSetter)imageTag{
    return ^(NSString *tag){
        QXThemeAttr *attr = [self new];
        attr.tag    = tag;
        attr.type   = QXThemeAttrTypeOfImage;
        return attr;
    };
}
+ (QXAttrTagSetter)textTag{
    return ^(NSString *tag){
        QXThemeAttr *attr = [self new];
        attr.tag    = tag;
        attr.type   = QXThemeAttrTypeOfText;
        return attr;
    };
}


+ (QXAttrTagSetter)otherTag{
    return ^(NSString *tag){
        QXThemeAttr *attr = [self new];
        attr.tag    = tag;
        attr.type   = QXThemeAttrTypeOfOther;
        return attr;
    };
}
@end


@implementation QXThemeStaff


- (NSMutableArray *)packs{
    if (!_packs) {
        _packs = [NSMutableArray arrayWithCapacity:1];
    }
    return _packs;
}



- (QXPacking)packing{
    return ^(SEL sel, NSArray *args){
        QXThemePack *pack = QXThemePack.new.setSel(sel).setArgs(args);
        [self.packs addObject:pack];
        return self;
    };
}

//- (void)dealloc{
//    NSLog(@"职员%@出去跑业务了", self);
//}




@end
