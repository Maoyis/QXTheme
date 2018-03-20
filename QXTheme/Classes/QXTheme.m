//
//  QxTheme.m
//  QXTheme
//
//  Created by lqx on 2018/3/14.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import "QXTheme.h"

@implementation UIColor (QXColorString)



+ (UIColor *)qx_colorWithHexString:(NSString *)hexString{
    
    if (!hexString) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 0:
            return nil;
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start: 0 length: 1];
            green = [self colorComponentFrom:colorString start: 1 length: 1];
            blue  = [self colorComponentFrom:colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start: 0 length: 1];
            red   = [self colorComponentFrom:colorString start: 1 length: 1];
            green = [self colorComponentFrom:colorString start: 2 length: 1];
            blue  = [self colorComponentFrom:colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start: 0 length: 2];
            green = [self colorComponentFrom:colorString start: 2 length: 2];
            blue  = [self colorComponentFrom:colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start: 0 length: 2];
            red   = [self colorComponentFrom:colorString start: 2 length: 2];
            green = [self colorComponentFrom:colorString start: 4 length: 2];
            blue  = [self colorComponentFrom:colorString start: 6 length: 2];
            break;
        default:
            alpha = 0, red = 0, blue = 0, green = 0;
            break;
    }
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

+ (CGFloat)colorComponentFrom:(NSString *) string start:(NSUInteger)start length:(NSUInteger) length{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}

+ (NSString *)qx_hexStringWithColor:(UIColor *)color{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    NSString *hexStr = [NSString stringWithFormat:@"#%.2x%.2x%.2x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
                        (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
                        (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
    return hexStr;
}

@end

@interface QXTheme ()

/**颜色字典*/
@property (nonatomic, strong) NSMutableDictionary *colors;
/**字体集合*/
@property (nonatomic, strong) NSMutableDictionary *fonts;
/**图片集合*/
@property (nonatomic, strong) NSMutableDictionary *imgs;
/**文字集合*/
@property (nonatomic, strong) NSMutableDictionary *texts;
/**其他*/
@property (nonatomic, strong) NSMutableDictionary *other;

@property (nonatomic, strong) UIColor *themeColor;




@end

@implementation QXTheme


#pragma mark===========默认配置===============

- (UIFont *)defaultFont{
    if (!_defaultFont) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat width = MIN(size.width, size.height);
        return [UIFont fontWithName:@"Helvetica Neue" size:15*width/320];
    }
    return _defaultFont;
}



#pragma mark===========  初始化 ===============
- (instancetype)initWithFileName:(NSString *)filename{
    NSArray *info = [filename componentsSeparatedByString:@"."];
    if (info.count>1) {
        NSString *suffix = [[info lastObject] lowercaseString];
        NSString *name   = [filename substringToIndex:filename.length-suffix.length-1];
        if ([suffix isEqualToString:@"plist"]) {
            return [self initWithPlistfile:name];
        }else if ([suffix isEqualToString:@"json"]){
            return [self initWithJsonfile:name];
        }
    }
    NSAssert(0, @"文件：%@：未知类型暂不支持，等待更新", filename);
    return self;
}

- (instancetype)initWithJsonfile:(NSString *)filename{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (!path) {
        return self;
    }
    if (self = [super init]) {
        self.name = filename;
        self.path = path;
        [self initDataWithJson];
    }
    return self;
}

- (instancetype)initWithPlistfile:(NSString *)filename{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    if (!path) {
        return self;
    }
    if (self = [super init]) {
        self.name = filename;
        self.path = path;
        [self initDataWithPlist];
    }
    return self;
}

- (void)initDataWithPlist{
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:self.path];
    NSAssert(data, @"添加的主题plist配置数据解析为空 - 请检查");
    [self setThemeDataWithFileInfo:data];
}
- (void)initDataWithJson{
    NSString *json = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
    NSError *jsonError = nil;
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    NSAssert(!jsonError, @"添加的主题json配置数据解析错误 - 错误描述");
    NSAssert(data, @"添加的主题json配置数据解析为空 - 请检查");
    if (!jsonError && data) {
        [self setThemeDataWithFileInfo:data];
    }
}


- (void)setThemeDataWithFileInfo:(NSDictionary *)data{
    id name = data[@"fontName"];
    if (name && [name isKindOfClass:[NSString class]]) {
        self.defaultFont = [UIFont fontWithName:name
                                           size:15]?:self.defaultFont;
    }
    id colors = data[@"color"];
    if (colors && [colors isKindOfClass:[NSDictionary class]]) {
        self.colors = [colors mutableCopy];
    }
    
    id imgs = data[@"image"];
    if (imgs && [imgs isKindOfClass:[NSDictionary class]]) {
        self.imgs = [imgs mutableCopy];
    }
    
    id fonts = data[@"font"];
    if (fonts && [fonts isKindOfClass:[NSDictionary class]]) {
        self.fonts = [fonts mutableCopy];
    }
    
    id texts = data[@"text"];
    if (texts && [texts isKindOfClass:[NSDictionary class]]) {
        self.texts = [texts mutableCopy];
    }
    
    id other = data[@"other"];
    if (other && [other isKindOfClass:[NSDictionary class]]) {
        self.other = [other mutableCopy];
    }
}

#pragma mark===========  Api  ===============

- (QXTheme *)changeThemeWithTag:(NSString *)tag
                     value:(id)value
                   tagType:(QXThemeTagType)type{
    if (type == QXThemeTagTypeOfRoot) {
        [self changeRootTag:tag value:value];
        return self;
    }
    switch (type) {
        case QXThemeTagTypeOfFont:
            [self.fonts setObject:tag forKey:value];
            break;
        case QXThemeTagTypeOfImage:
            [self.imgs setObject:value forKey:tag];
            break;
        case QXThemeTagTypeOfText:
            [self.texts setObject:value forKey:tag];
            break;
        case QXThemeTagTypeOfColor:
            [self.colors setObject:value forKey:tag];
            break;
        case QXThemeTagTypeOfOther:
            [self.other setObject:value forKey:tag];
            break;
        default:
            break;
    }
    return self;
}


- (void)changeRootTag:(NSString *)tag value:(id)value{
    if ([tag isEqualToString:@"fontName"]) {
        if (value && [value isKindOfClass:[NSString class]]) {
            self.defaultFont = [UIFont fontWithName:value
                                               size:15]?:self.defaultFont;
        }
    }
}



#pragma mark=========== 属性匹配 ===============
- (UIColor *)getColorWithTag:(NSString *)tag{
    NSString *rgbStr = self.colors[tag];
    return [UIColor qx_colorWithHexString:rgbStr]?:[UIColor clearColor];
}

- (UIImage *)getImgWithTag:(NSString *)tag{
    NSString *name = self.imgs[tag];
    return [UIImage imageNamed:name]?:[UIImage new];
}

- (UIFont *)getFontWithTag:(NSString *)tag{
    NSDictionary *data = self.fonts[tag];
    NSString *name     = data[@"name"]?:self.defaultFont.fontName;
    CGFloat   size     = [data[@"size"] floatValue] ?: [self.defaultFont pointSize];
    UIFont *font = [UIFont fontWithName:name size:size];
    return font;
}

- (NSString *)getTextWithTag:(NSString *)tag{
    NSString *text = self.texts[tag];
    return text?:@"";
}



- (id)getOtherWithTag:(NSString *)tag{
    id other = self.other[tag];
    return other?:[NSNull new];
}
@end
