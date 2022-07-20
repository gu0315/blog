//
//  RootViewControllerConfiguration.m
//  Template
//
//  Created by 顾钱想 on 2022/7/19.
//

#import "RootViewControllerConfiguration.h"
#import <RootViewController/RootViewController-Swift.h>
#import <objc/runtime.h>

char *kRootViewControllerConfiguration InjectableDATA = "+[RootViewControllerConfiguration(FBInjectable) fb_injectable]";

@implementation RootViewControllerConfiguration

+ (long)integrationPriority {
    return  0;
}

+ (void)fb_injectable {
    NSLog(@"开始初始化");
    [RootViewController setRootViewController];
}

@end
