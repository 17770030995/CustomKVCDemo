//
//  NSObject+KVC.h
//  CustomCategoryDemo
//
//  Created by 李传熔 on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVC)

-(void)lcr_setValue:(nullable id)value forKey:(NSString *)key;

-(nullable id)lcr_getValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
