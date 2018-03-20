//
//  QXThemePacker.h
//  QXTheme
//
//  Created by lqx on 2018/3/13.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import <Foundation/Foundation.h>




@class QXThemePack;
@class QXThemeAttr;

typedef QXThemePack*(^QXSelSetter)(SEL sel);
typedef QXThemePack*(^QXArgsSetter) (NSArray *args);


/**
 订购产品
 */
@interface QXThemePack : NSObject

@property (nonatomic, assign) SEL sel;
@property (nonatomic, strong) NSArray  *args;




- (QXSelSetter)setSel;
- (QXArgsSetter)setArgs;





@end


typedef NS_ENUM(NSInteger, QXThemeAttrType) {
    /**颜色*/
    QXThemeAttrTypeOfColor,
    /**图片*/
    QXThemeAttrTypeOfImage,
    /**字体*/
    QXThemeAttrTypeOfFont,
    /**文字*/
    QXThemeAttrTypeOfText,
    /**其他*/
    QXThemeAttrTypeOfOther,
};

#define COLOR_ATTR(str) QXThemeAttr.colorTag(str)
#define IMAGE_ATTR(str) QXThemeAttr.imageTag(str)
#define FONT_ATTR(str)  QXThemeAttr.fontTag(str)
#define TEXT_ATTR(str)  QXThemeAttr.textTag(str)
#define OTHER_ATTR(str) QXThemeAttr.otherTag(str)


typedef QXThemeAttr*(^QXAttrTagSetter) (NSString  *tag);


/**主题属性*/
@interface QXThemeAttr : NSObject

@property (nonatomic, assign) QXThemeAttrType type;
/**属性标签*/
@property (nonatomic, copy  ) NSString  *tag;
@property (nonatomic, strong) id attrValue;

+ (QXAttrTagSetter)colorTag;
+ (QXAttrTagSetter)fontTag;
+ (QXAttrTagSetter)imageTag;
+ (QXAttrTagSetter)textTag;
+ (QXAttrTagSetter)otherTag;

@end





@class QXThemeStaff;
/**
 打包业务

 @param sel  业务
 @param args 业务备注信息
 */
typedef QXThemeStaff *(^QXPacking)(SEL sel, NSArray *args);

/**
 服务人员（一对一专属服务）
 */
@interface QXThemeStaff : NSObject


/**客户*/
@property (nonatomic, assign) id customer;


@property (nonatomic, strong) NSMutableArray *packs;







/**
 整理并打包业务
 */
- (QXPacking)packing;





@end








