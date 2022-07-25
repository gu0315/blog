//
//  SCCViewControllerModuleConfig.m
//  Pods
//
//  Created by 葛亮 on 16/8/2.
//
//

#import "SCCViewControllerModuleConfig.h"

@implementation SCCViewControllerModuleConfig

+ (instancetype)config {
    static SCCViewControllerModuleConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[SCCViewControllerModuleConfig alloc] init];
    });
    return config;
}

@end
