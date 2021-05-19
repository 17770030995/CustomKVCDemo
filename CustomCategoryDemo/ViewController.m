//
//  ViewController.m
//  CustomCategoryDemo
//
//  Created by 李传熔 on 2021/5/18.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *per = [[Person alloc]init];
    [per lcr_setValue:@"lcr" forKey:@"name"];

    NSLog(@"%@",[per lcr_getValueForKey:@"name"]);
}


@end
