//
//  NSObject+KVC.m
//  CustomCategoryDemo
//
//  Created by 李传熔 on 2021/5/18.
//

#import "NSObject+KVC.h"
#import <objc/runtime.h>

@implementation NSObject (KVC)

-(void)lcr_setValue:(id)value forKey:(NSString *)key
{
    //1.判断key是否存在
    if (key == nil || key.length == 0) return;
    
    //找setter 顺序是：setKey \ _setKey \setIsKey
    NSString *Key = key.capitalizedString;
    
    NSString *setKey = [NSString stringWithFormat:@"set%@:",Key];
    NSString *_setKey = [NSString stringWithFormat:@"_set%@:",Key];
    NSString *setIsKey = [NSString stringWithFormat:@"setIs%@:",Key];

    if ([self lcr_performSelectorWithMethodName:setKey value:value]){
        NSLog(@"setKey");
        return;
    }else if ([self lcr_performSelectorWithMethodName:_setKey value:value]){
        NSLog(@"_setKey");
        return;
    }else if ([self lcr_performSelectorWithMethodName:setIsKey value:value]){
        NSLog(@"setIsKey");
        return;
    }
    
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"LGUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
    NSMutableArray *mArray = [self getIvarListName];
    NSString *_key = [NSString stringWithFormat:@"_%@",key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@",Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@",Key];
    
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }else if ([mArray containsObject:_isKey]){
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }else if ([mArray containsObject:key]){
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }else if ([mArray containsObject:isKey]){
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    // 5:如果找不到相关实例
    @throw [NSException exceptionWithName:@"LGUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ %@]: this class is not key value coding-compliant for the key name.****",self,NSStringFromSelector(_cmd)] userInfo:nil];
}

-(nullable id)lcr_getValueForKey:(NSString *)key
{
    if (key == nil || key.length == 0) return nil;
    
    NSString *Key = key.capitalizedString;
    // 拼接方法
    NSString *getKey = [NSString stringWithFormat:@"get%@",Key];
    NSString *countOfKey = [NSString stringWithFormat:@"countOf%@",Key];
    NSString *objectInKeyAtIndex = [NSString stringWithFormat:@"objectIn%@AtIndex:",Key];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:NSSelectorFromString(getKey)]) {
        return [self performSelector:NSSelectorFromString(getKey)];
    }else if ([self respondsToSelector:NSSelectorFromString(key)]){
        return [self performSelector:NSSelectorFromString(key)];
    }else if ([self respondsToSelector:NSSelectorFromString(countOfKey)]){
        if ([self respondsToSelector:NSSelectorFromString(objectInKeyAtIndex)]) {
            int num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray *marray = [NSMutableArray array];
            for (int i= 0; i < num - 1; i ++) {
                num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            }
            
            for (int j = 0; j < num; j ++) {
                id objc = [self performSelector:NSSelectorFromString(objectInKeyAtIndex) withObject:@(num)];
                [marray addObject:objc];
            }
            return marray;
        }
    }
#pragma clang diagnostic pop
    
    if (![self.class accessInstanceVariablesDirectly] ) {
        @throw [NSException exceptionWithName:@"LGUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
    NSMutableArray *mArray = [self getIvarListName];
    
    NSString *_key = [NSString stringWithFormat:@"_%@",key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@",Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@",Key];
    
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        return object_getIvar(self, ivar);
    }else if ([mArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        return object_getIvar(self, ivar);;
    }
    
    return @"";
    
}

-(BOOL)lcr_performSelectorWithMethodName:(NSString *)methodName value:(id)value{
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(methodName) withObject:value];
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}

-(id)performSelectorWithMethodName:(NSString *)methodName{
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
        return [self performSelector:NSSelectorFromString(methodName)];
    }
    return nil;
}

-(NSMutableArray *)getIvarListName{
    NSMutableArray *mArray = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0;i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *ivarNameChar = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivarNameChar];
        //NSLog(@"ivarName = %@",ivarName);
        [mArray addObject:ivarName];
    }
    free(ivars);
    return mArray;
}

@end
