//
//  QXThemeModifier.m
//  QXTheme
//
//  Created by lqx on 2018/3/13.
//  Copyright © 2018年 lqx. All rights reserved.
//

#import "QXThemeCourier.h"
#import "QXThemeManager.h"

@implementation QXThemeCourier

/**
 个体服务
 */
- (void)qx_deliverByStaff:(QXThemeStaff *)staff{
    for (QXThemePack *pack in staff.packs) {
        @try {
            [self performSel:pack.sel args:pack.args target:staff.customer];
        } @catch (NSException *exception) {
            QXTheme_Log(@"\n--------\n ui:%@ \n pack:%@ \n------崩溃原因----\n%@\n--------\n", staff.customer, pack.description, exception);
        } @finally {
            continue;
        }
        
    }
}

/**
 简单的验证
 */
- (void)verifySel:(SEL)sel  args:(NSArray *)args target:(id)target{
    NSString *selName = NSStringFromSelector(sel);
    //判断是否存在该方法
    NSAssert([target respondsToSelector:sel], @"%@不存在该方法%@", [target class], selName);
    //判断该方法参数个数是否对应（要求nil必须传空）
    NSInteger count = [selName length] - [[selName stringByReplacingOccurrencesOfString:@":" withString:@""] length];
    BOOL flag = args.count==count;
    NSAssert(flag, @"[%@]参数数量不匹配，要求数量：%ld,实际数量：%ld", selName, count, args.count);
    
    
}
/**
 主题变更实际执行方法
 */
- (id)performSel:(SEL)sel  args:(NSArray *)args target:(id)target{
    if (sel == nil) return nil;
    [self verifySel:sel args:args target:target];
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = sel;
    
    // invocation 有2个隐藏参数，所以 argument 从2开始
    if ([args isKindOfClass:[NSArray class]]) {
        NSInteger count = MIN(args.count, signature.numberOfArguments - 2);
        for (int i = 0; i < count; i++) {
            const char *type = [signature getArgumentTypeAtIndex:2 + i];
            
            // 需要做参数类型判断然后解析成对应类型，这里默认所有参数均为OC对象
            id value = [self getArgumentWithArgs:args index:i];
            [self setInvocation:invocation Argument:value type:type atIndex:i];
        }
    }
    [invocation invoke];
    id returnVal;
    if (strcmp(signature.methodReturnType, "@") == 0) {
        [invocation getReturnValue:&returnVal];
    }
    // 需要做返回类型判断。比如返回值为常量需要包装成对象，这里仅以最简单的`@`为例
    //需要进一步判断，由于应用与主题设置不牵扯返回值，以后使用持续优化
    return returnVal;
}

/**
 配置对应位置参数
 */
- (void)setInvocation:(NSInvocation *)invocation Argument:(id)argument type:(const char *)type atIndex:(NSInteger)index{
    if ([argument isKindOfClass:[NSNull class]]) {
        [invocation setArgument:&argument atIndex:2+index];
        return;
    }
    if (strcmp(type, "@") == 0) {//obj
        [invocation setArgument:&argument atIndex:2+index];
    }else if (strcmp(type, "B") == 0){//BOOL
        BOOL value = [argument boolValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "f") == 0){//integer、枚举
        float value = [argument floatValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "d") == 0){//
        double value = [argument doubleValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "c") == 0){//
        char value = [argument charValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "C") == 0){//
        unsigned char value = [argument unsignedCharValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "i") == 0){//
        int value = [argument intValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "I") == 0){//
        unsigned int value = [argument unsignedIntValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "i") == 0){//
        int value = [argument intValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "s") == 0){//
        short value = [argument shortValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "S") == 0){
        unsigned short value = [argument unsignedShortValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "l") == 0){
        long value = [argument longValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "L") == 0){
        unsigned long value = [argument unsignedLongValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "q") == 0){
        long long value = [argument longLongValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "Q") == 0){
        unsigned long long value = [argument unsignedLongLongValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "{CGRect={CGPoint=dd}{CGSize=dd}}") == 0){
        CGRect value = [argument CGRectValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "{CGPoint=dd}") == 0){
        CGPoint value = [argument CGPointValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "{CGSize=dd}") == 0){
        CGSize value = [argument CGSizeValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "{UIEdgeInsets=dddd}}") == 0){
        UIEdgeInsets value = [argument UIEdgeInsetsValue];
        [invocation setArgument:&value atIndex:2+index];
    }else if (strcmp(type, "^{CGColor=}") == 0){
        CGColorRef value = [argument CGColor];
        [invocation setArgument:&value atIndex:2+index];
    }
    

    else{
        NSAssert(0, @"由于处理不够完善，出现未知情况:\n\"%s\"\n,请通知作者更新", type);
    }
    //后续待完善--如急需使用，推荐使用分类重写该方法
}

#pragma mark=========== 特殊参数处理（待完善）  ===============
- (id)getArgumentWithArgs:(NSArray *)args index:(int)index{
    id arg = args[index];
    return [self handleSpecialArg:arg];
}

/**
 特殊参数处理（可自定义分类扩展）
 */
- (id)handleSpecialArg:(id)arg{
    if ([arg isKindOfClass:[QXThemeAttr class]]) {
        return [self handleThemeAtrrArg:arg];
    }else if ([arg isKindOfClass:[NSDictionary class]]) {
        return [self handleDicArg:arg];
    }else if ([arg isKindOfClass:[NSArray class]]) {
        return [self handleArrArg:arg];
    }else if ([arg isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return arg;
}

/**
 参数为  QXThemeAttr
 */
- (id)handleThemeAtrrArg:(QXThemeAttr *)arg{
    QXThemeAttrType type = [arg type];
    NSString *tag        = [arg tag];
    id value;
    switch (type) {
        case QXThemeAttrTypeOfFont:
            value = QX_FONT(tag);
            break;
        case QXThemeAttrTypeOfColor:
            value = QX_COLOR(tag);
            break;
        case QXThemeAttrTypeOfImage:
            value = QX_IMG(tag);
            break;
        case QXThemeAttrTypeOfText:
            value = QX_TEXT(tag);
            break;
        case QXThemeAttrTypeOfOther:
            value = QX_OTHER(tag);
            break;
        default:
            break;
    }
    //此处需要强引用value，避免value被释放
    [arg setAttrValue:value];
    return value;
}


/**
 参数为字典
 */
- (id)handleDicArg:(NSDictionary *)arg{
    NSMutableDictionary*data = [NSMutableDictionary new];
    for (id key in arg) {
        id value = arg[key];
        id newValue = [self handleSpecialArg:value];
        @try {
            [data setObject:newValue forKey:key];
        } @catch (NSException *exception) {
            QXTheme_Log(@"原参数字典为：arg：%@\n--------exception------\nname:%@, reason:%@", arg, exception.name, exception.reason);
        } @finally {
            continue;
        }
        
    }
    return data;
}

/**
 参数为数组
 */
- (id)handleArrArg:(NSArray *)arg{
    NSMutableArray*data = [NSMutableArray new];
    for (id value in arg) {
        id newValue = [self handleSpecialArg:value];
        @try {
            [data addObject:newValue];
        } @catch (NSException *exception) {
            QXTheme_Log(@"原参数数组为：arg：%@\n--------exception------\nname:%@, reason:%@", arg, exception.name, exception.reason);
        } @finally {
            continue;
        }
    }
    return data;
}
@end

