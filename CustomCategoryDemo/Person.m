//
//  Person.m
//  CustomCategoryDemo
//
//  Created by 李传熔 on 2021/5/18.
//

#import "Person.h"

@implementation Person

+(BOOL)accessInstanceVariablesDirectly{
    return YES;
}


//- (void)setName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}

//- (void)_setName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}

//- (void)setIsName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}

//-(NSString *)getName{
//    return NSStringFromSelector(_cmd);
//}

//-(NSString *)name{
//    return NSStringFromSelector(_cmd);
//}

//- (NSUInteger)countOfName{
//    NSLog(@"%s",__func__);
//    return 10;
//}
//
//- (NSString *)objectInNameAtIndex:(NSUInteger)index {
//    NSLog(@"%s",__func__);
//    return [NSString stringWithFormat:@"Name %lu", index];
//}


@end
